//
//  PostsFrontPageModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class PostsFrontPageModel: NSObject {
    var goToPostScreen: ((LemmyModel.PostView) -> Void)?
    var goToCommunityScreen: ((_ fromPost: LemmyModel.PostView) -> Void)?
    var goToProfileScreen: ((_ username: String) -> Void)?
    var newDataLoaded: (([LemmyModel.PostView]) -> Void)?
    var dataLoaded: (([LemmyModel.PostView]) -> Void)?
    
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
                                                         limit: 20,
                                                         communityId: nil,
                                                         communityName: nil,
                                                         auth: LemmyShareData.shared.jwtToken)
        
        ApiManager.shared.requestsManager.getPosts(
            parameters: parameters,
            completion: { (dec: Result<LemmyModel.Post.GetPostsResponse, LemmyGenericError>) in
                switch dec {
                case .success(let posts):
                    self.postsDataSource = posts.posts
                    self.dataLoaded?(posts.posts)
                case .failure(let error):
                    print(error)
                }
            })
    }
    
    func loadMorePosts(completion: @escaping (() -> Void)) {
        let parameters = LemmyModel.Post.GetPostsRequest(type: self.currentFeedType,
                                                         sort: currentSortType,
                                                         page: currentPage,
                                                         limit: 20,
                                                         communityId: nil,
                                                         communityName: nil,
                                                         auth: LemmyShareData.shared.jwtToken)
        
        ApiManager.shared.requestsManager.getPosts(
            parameters: parameters,
            completion: { (dec: Result<LemmyModel.Post.GetPostsResponse, LemmyGenericError>) in
                switch dec {
                case let .success(posts):
                    self.newDataLoaded?(posts.posts)
                    completion()
                case .failure(let error):
                    print(error)
                }
            })
    }
}

extension PostsFrontPageModel: PostContentTableCellDelegate {
    func usernameTapped(in post: LemmyModel.PostView) {
        goToProfileScreen?(post.creatorName)
    }
    
    // TODO(uuttff8): Implement coordinator to post
    func communityTapped(in post: LemmyModel.PostView) {        
        goToCommunityScreen?(post)
    }
    
    func upvote(post: LemmyModel.PostView) {
        print("upvote")
    }
    
    func downvote(post: LemmyModel.PostView) {
        print("downvote")
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
