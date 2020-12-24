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
    var goToPostScreen: ((LemmyModel.PostView) -> Void)?
    var goToCommunityScreen: ((_ fromPost: LemmyModel.PostView) -> Void)?
    var goToProfileScreen: ((_ userId: Int) -> Void)?
    var onLinkTap: ((URL) -> Void)?
    var newDataLoaded: (([LemmyModel.PostView]) -> Void)?
    var dataLoaded: (([LemmyModel.PostView]) -> Void)?
    
    private let upvoteDownvoteService = UpvoteDownvoteRequestService(userAccountService: UserAccountService())
    
    private var cancellable = Set<AnyCancellable>()
    
    var isFetchingNewContent = false
    var currentPage = 1
    
    var postsDataSource: [LemmyModel.PostView] = []
    
    // at init always posts
    var currentContentType: LemmyContentType = LemmyContentType.posts {
        didSet {
            print(currentContentType)
        }
    }
    
    // at init always all
    var currentFeedType: LemmyPostListingType = LemmyPostListingType.all {
        didSet {
            self.currentPage = 1
            print(currentFeedType)
        }
    }
    
    var currentSortType: LemmySortType = LemmySortType.active {
        didSet {
            self.currentPage = 1
        }
    }
    
    func loadPosts() {
        let parameters = LemmyModel.Post.GetPostsRequest(type: self.currentFeedType,
                                                         sort: currentSortType,
                                                         page: 1,
                                                         limit: 50,
                                                         communityId: nil,
                                                         communityName: nil,
                                                         auth: LemmyShareData.shared.jwtToken)
        
        ApiManager.shared.requestsManager.asyncGetPosts(parameters: parameters)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
            } receiveValue: { (response) in
                self.postsDataSource = response.posts
                self.dataLoaded?(response.posts)
            }.store(in: &cancellable)
    }
    
    func loadMorePosts(completion: @escaping (() -> Void)) {
        let parameters = LemmyModel.Post.GetPostsRequest(type: self.currentFeedType,
                                                         sort: currentSortType,
                                                         page: currentPage,
                                                         limit: 50,
                                                         communityId: nil,
                                                         communityName: nil,
                                                         auth: LemmyShareData.shared.jwtToken)
        
        ApiManager.requests.asyncGetPosts(parameters: parameters)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
            } receiveValue: { (response) in
                self.newDataLoaded?(response.posts)
                completion()

            }.store(in: &cancellable)
    }
    
    func getPost(by id: LemmyModel.PostView.ID) -> LemmyModel.PostView? {
        if let index = postsDataSource.firstIndex(where: { $0.id == id }) {
            return postsDataSource[index]
        }
        
        return nil
    }
    
    private func saveNewPost(_ post: LemmyModel.PostView) {
        postsDataSource.updateElementById(post)
    }
    
    func createPostLike(newVote: LemmyVoteType, post: LemmyModel.PostView) {
        self.upvoteDownvoteService.createPostLike(vote: newVote, post: post)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
            } receiveValue: { (post) in
                self.saveNewPost(post)
            }.store(in: &cancellable)
    }
}

extension PostsFrontPageModel: FrontPageHeaderCellDelegate {
    func contentTypeChanged(to content: LemmyContentType) {
        self.currentContentType = content
        //        self.loadPosts()
    }
    
    func feedTypeChanged(to feed: LemmyPostListingType) {
        self.currentFeedType = feed
        //        self.loadPosts()
    }
}
