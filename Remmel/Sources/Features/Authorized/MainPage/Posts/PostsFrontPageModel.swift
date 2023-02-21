//
//  PostsFrontPageModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine
import RMModels
import RMServices
import RMNetworking
import RMFoundation

class PostsFrontPageModel: NSObject {
    var newDataLoaded: (() -> Void)?
    var dataLoaded: (() -> Void)?
    var createPostLikeUpdate: ((_ index: Int) -> Void)?
    
    private let contentScoreService = ContentScoreService(userAccountService: UserAccountService())
    private let contentPreferenceService = ContentPreferencesStorageManager()
    
    private weak var wsEvents = ApiManager.chainedWsCLient
    
    private var cancellable = Set<AnyCancellable>()
    
    var isFetchingNewContent = false
    var currentPage = 1
    
    var postsDataSource: [RMModels.Views.PostView] = []
    
    var currentSortType: RMModels.Others.SortType {
        get { contentPreferenceService.contentSortType }
        set {
            self.currentPage = 1
            contentPreferenceService.contentSortType = newValue
        }
    }
    
    var currentListingType: RMModels.Others.ListingType {
        get { contentPreferenceService.listingType }
        set {
            self.currentPage = 1
            contentPreferenceService.listingType = newValue
        }
    }
    
    func receiveMessages() {
        
        wsEvents?.onTextMessage.addObserver(self, completionHandler: { [weak self] operation, data in
            switch operation {
            case RMUserOperation.CreatePostLike.rawValue:
                
                guard let postLike = self?.wsEvents?.decodeWsType(
                    RMModels.Api.Post.PostResponse.self,
                    data: data
                ) else { return }
                
                DispatchQueue.main.async {
                    self?.createPostLike(with: postLike.postView)
                }
                
            case RMUserOperation.EditPost.rawValue,
                 RMUserOperation.DeletePost.rawValue,
                 RMUserOperation.RemovePost.rawValue,
                 RMUserOperation.LockPost.rawValue,
                 RMUserOperation.StickyPost.rawValue,
                 RMUserOperation.SavePost.rawValue:
                
                guard let newPost = self?.wsEvents?.decodeWsType(
                    RMModels.Api.Post.PostResponse.self,
                    data: data
                ) else { return }
                
                DispatchQueue.main.async {
                    self?.updatePost(with: newPost.postView)
                }
            default:
                break
            }
        })
    }
    
    func loadPosts() {
        let parameters = RMModels.Api.Post.GetPosts(type: self.currentListingType,
                                                    sort: self.currentSortType,
                                                    page: 1,
                                                    limit: 50,
                                                    communityId: nil,
                                                    communityName: nil,
                                                    savedOnly: false,
                                                    auth: LemmyShareData.shared.jwtToken)
        
        ApiManager.requests.asyncGetPosts(parameters: parameters)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                Logger.logCombineCompletion(completion)
            } receiveValue: { response in
                self.postsDataSource = response.posts
                self.dataLoaded?()
            }.store(in: &cancellable)
    }
    
    func loadMorePosts(completion: @escaping (() -> Void)) {
        let parameters = RMModels.Api.Post.GetPosts(type: self.currentListingType,
                                                    sort: self.currentSortType,
                                                    page: self.currentPage,
                                                    limit: 50,
                                                    communityId: nil,
                                                    communityName: nil,
                                                    savedOnly: false,
                                                    auth: LemmyShareData.shared.jwtToken)
        
        ApiManager.requests.asyncGetPosts(parameters: parameters)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                Logger.logCombineCompletion(completion)
            } receiveValue: { response in
                self.postsDataSource.append(contentsOf: response.posts)
                self.newDataLoaded?()
                completion()
                
            }.store(in: &cancellable)
    }
    
    private func saveNewPost(_ post: RMModels.Views.PostView) {
        postsDataSource.updateElementById(post)
    }
    
    func createPostLike(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        for newVote: LemmyVoteType,
        post: RMModels.Views.PostView
    ) {
        scoreView.setVoted(voteButton: voteButton, to: newVote)
        self.contentScoreService.votePost(for: newVote, post: post)
    }
    
    private func createPostLike(with updatedPost: RMModels.Views.PostView) {
        if let index = self.postsDataSource.getElementIndex(by: updatedPost.id) {
            #warning("There is no updateForCreatePostLike")
//            self.postsDataSource[index].updateForCreatePostLike(with: updatedPost)
            self.createPostLikeUpdate?(index)
        }
    }
    
    private func updatePost(with updatedPost: RMModels.Views.PostView) {
        if let index = self.postsDataSource.getElementIndex(by: updatedPost.id) {
            self.postsDataSource[index] = updatedPost
        }
    }
}
