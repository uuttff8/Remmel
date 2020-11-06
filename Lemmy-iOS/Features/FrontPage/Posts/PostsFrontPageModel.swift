//
//  PostsFrontPageModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class PostsFrontPageModel: NSObject {
    var goToPostScreen: ((LemmyApiStructs.PostView) -> Void)?
    var goToCommunityScreen: ((_ fromPost: LemmyApiStructs.PostView) -> Void)?
    var newDataLoaded: (([LemmyApiStructs.PostView]) -> Void)?
    var dataLoaded: (([LemmyApiStructs.PostView]) -> Void)?

    var isFetchingNewContent = false
    var currentPage = 1

    var postsDataSource: [LemmyApiStructs.PostView] = []

    // at init always posts
    var currentContentType: LemmyContentType = LemmyContentType.posts {
        didSet {
            print(currentContentType)
        }
    }

    // at init always all
    var currentFeedType: LemmyPostListingType = LemmyPostListingType.all {
        didSet {
            print(currentFeedType)
        }
    }
    
    var currentSortType: LemmySortType = LemmySortType.active

    func loadPosts() {
        let parameters = LemmyApiStructs.Post.GetPostsRequest(type: self.currentFeedType,
                                                              sort: currentSortType,
                                                              page: 1,
                                                              limit: 20,
                                                              communityId: nil,
                                                              communityName: nil,
                                                              auth: nil)

        ApiManager.shared.requestsManager.getPosts(
            parameters: parameters,
            completion: { (dec: Result<LemmyApiStructs.Post.GetPostsResponse, LemmyGenericError>) in
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
        let parameters = LemmyApiStructs.Post.GetPostsRequest(type: self.currentFeedType,
                                                              sort: currentSortType,
                                                              page: currentPage,
                                                              limit: 20,
                                                              communityId: nil,
                                                              communityName: nil,
                                                              auth: nil)

        ApiManager.shared.requestsManager.getPosts(
            parameters: parameters,
            completion: { (dec: Result<LemmyApiStructs.Post.GetPostsResponse, LemmyGenericError>) in
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
    func usernameTapped(in post: LemmyApiStructs.PostView) {
        print(post.creatorName)
    }

    // TODO(uuttff8): Implement coordinator to post
    func communityTapped(in post: LemmyApiStructs.PostView) {        
        goToCommunityScreen?(post)
    }

    func upvote(post: LemmyApiStructs.PostView) {
        print("upvote")
    }

    func downvote(post: LemmyApiStructs.PostView) {
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
