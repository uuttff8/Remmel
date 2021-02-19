//
//  PostsFrontPageModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

class PostsFrontPageModel: NSObject {
    var newDataLoaded: (() -> Void)?
    var dataLoaded: (() -> Void)?
    var createPostLikeUpdate: ((_ index: Int) -> Void)?
    
    private let contentScoreService = ContentScoreService(userAccountService: UserAccountService())
    private let contentPreferenceService = ContentPreferencesStorageManager()
    
    private let wsEvents = ApiManager.chainedWsCLient
    
    private var cancellable = Set<AnyCancellable>()
    
    var isFetchingNewContent = false
    var currentPage = 1
    
    var postsDataSource: [LMModels.Views.PostView] = []
    
    var currentSortType: LMModels.Others.SortType {
        get { contentPreferenceService.contentSortType }
        set {
            self.currentPage = 1
            contentPreferenceService.contentSortType = newValue
        }
    }
    
    var currentListingType: LMModels.Others.ListingType {
        get { contentPreferenceService.listingType }
        set {
            self.currentPage = 1
            contentPreferenceService.listingType = newValue
        }
    }
    
    func receiveMessages() {
        wsEvents?
            .onMessage(completion: { (operation, data) in
                
                switch operation {
                case LMMUserOperation.CreatePostLike.rawValue:
                    
                    guard let postLike = self.wsEvents?.decodeWsType(LMModels.Api.Post.PostResponse.self, data: data)
                    else { return }
                    
                    self.updatePostCell(with: postLike.postView)
                    
                default:
                    break
                }
                
            })
        
        let commJoin = LMModels.Api.Websocket.CommunityJoin(communityId: 0)

        wsEvents?.send(
            WSEndpoint.Community.communityJoin.endpoint,
            parameters: commJoin
        )
    }
    
    func loadPosts() {
        let parameters = LMModels.Api.Post.GetPosts(type: self.currentListingType,
                                                    sort: self.currentSortType,
                                                    page: 1,
                                                    limit: 50,
                                                    communityId: nil,
                                                    communityName: nil,
                                                    auth: LemmyShareData.shared.jwtToken)
        
        ApiManager.requests.asyncGetPosts(parameters: parameters)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
            } receiveValue: { (response) in
                self.postsDataSource = response.posts
                self.dataLoaded?()
            }.store(in: &cancellable)
    }
    
    func loadMorePosts(completion: @escaping (() -> Void)) {
        let parameters = LMModels.Api.Post.GetPosts(type: self.currentListingType,
                                                    sort: self.currentSortType,
                                                    page: self.currentPage,
                                                    limit: 50,
                                                    communityId: nil,
                                                    communityName: nil,
                                                    auth: LemmyShareData.shared.jwtToken)
        
        ApiManager.requests.asyncGetPosts(parameters: parameters)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
            } receiveValue: { (response) in
                self.postsDataSource.append(contentsOf: response.posts)
                self.newDataLoaded?()
                completion()
                
            }.store(in: &cancellable)
    }
        
    private func saveNewPost(_ post: LMModels.Views.PostView) {
        postsDataSource.updateElementById(post)
    }
    
    func createPostLike(newVote: LemmyVoteType, post: LMModels.Views.PostView) {
        self.contentScoreService.createPostLike(vote: newVote, postId: post.id)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
            } receiveValue: { (post) in
                self.saveNewPost(post)
            }.store(in: &cancellable)
    }
    
    private func updatePostCell(with updatedPost: LMModels.Views.PostView) {
        if let index = self.postsDataSource.getElementIndex(by: updatedPost.id) {
            self.postsDataSource[index].updateForCreatePostLike(with: updatedPost)
            self.createPostLikeUpdate?(index)
        }
    }    
}
