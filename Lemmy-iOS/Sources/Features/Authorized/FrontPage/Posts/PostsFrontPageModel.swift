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
    
    private weak var wsEvents = ApiManager.chainedWsCLient
    
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
        
        wsEvents?.onTextMessage.addObserver(self, completionHandler: { [weak self] operation, data in
            switch operation {
            case LMMUserOperation.CreatePostLike.rawValue:
                
                guard let postLike = self?.wsEvents?.decodeWsType(
                    LMModels.Api.Post.PostResponse.self,
                    data: data
                ) else { return }
                
                DispatchQueue.main.async {
                    self?.createPostLike(with: postLike.postView)
                }
                
            case LMMUserOperation.EditPost.rawValue,
                 LMMUserOperation.DeletePost.rawValue,
                 LMMUserOperation.RemovePost.rawValue,
                 LMMUserOperation.LockPost.rawValue,
                 LMMUserOperation.StickyPost.rawValue,
                 LMMUserOperation.SavePost.rawValue:
                
                guard let newPost = self?.wsEvents?.decodeWsType(
                    LMModels.Api.Post.PostResponse.self,
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
        let parameters = LMModels.Api.Post.GetPosts(type: self.currentListingType,
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
        let parameters = LMModels.Api.Post.GetPosts(type: self.currentListingType,
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
    
    private func saveNewPost(_ post: LMModels.Views.PostView) {
        postsDataSource.updateElementById(post)
    }
    
    func createPostLike(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        for newVote: LemmyVoteType,
        post: LMModels.Views.PostView
    ) {
        self.contentScoreService.votePost(scoreView: scoreView, voteButton: voteButton, for: newVote, post: post)
    }
    
    private func createPostLike(with updatedPost: LMModels.Views.PostView) {
        if let index = self.postsDataSource.getElementIndex(by: updatedPost.id) {
            self.postsDataSource[index].updateForCreatePostLike(with: updatedPost)
            self.createPostLikeUpdate?(index)
        }
    }
    
    private func updatePost(with updatedPost: LMModels.Views.PostView) {
        if let index = self.postsDataSource.getElementIndex(by: updatedPost.id) {
            self.postsDataSource[index] = updatedPost
        }
    }
}
