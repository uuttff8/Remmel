//
//  ProfileScreenPostsViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

protocol ProfileScreenPostsViewModelProtocol {
    func doNextPostsFetch(request: ProfileScreenPosts.NextProfilePostsLoad.Request)
    func doPostLike(voteButton: VoteButton, for newVote: LemmyVoteType, post: LemmyModel.PostView) 
}

class ProfileScreenPostsViewModel: ProfileScreenPostsViewModelProtocol {
    typealias PaginationState = (page: Int, hasNext: Bool)
        
    private let contentScoreService: ContentScoreServiceProtocol
    
    weak var viewController: ProfileScreenPostViewControllerProtocol?
    
    private var paginationState = PaginationState(page: 1, hasNext: true)
    
    var cancellable = Set<AnyCancellable>()
    
    init(contentScoreService: ContentScoreServiceProtocol) {
        self.contentScoreService = contentScoreService
    }
    
    func doNextPostsFetch(request: ProfileScreenPosts.NextProfilePostsLoad.Request) {
        self.paginationState.page += 1
        
        let params = LemmyModel.Post.GetPostsRequest(type: .all,
                                                     sort: request.contentType,
                                                     page: paginationState.page,
                                                     limit: 50,
                                                     communityId: nil,
                                                     communityName: nil,
                                                     auth: LemmyShareData.shared.jwtToken)
        
        ApiManager.requests.asyncGetPosts(parameters: params)
            .receive(on: RunLoop.main)
            .sink { (error) in
                print(error)
            } receiveValue: { (response) in
                
                self.viewController?.displayNextPosts(
                    viewModel: .init(
                        state: .result(data: response.posts)
                    )
                )
                
            }.store(in: &cancellable)
    }
    
    func doPostLike(voteButton: VoteButton, for newVote: LemmyVoteType, post: LemmyModel.PostView) {
        self.contentScoreService.votePost(voteButton: voteButton, for: newVote, post: post) { (post) in
            // save this post to table data source
        }
    }

}

extension ProfileScreenPostsViewModel: ProfileScreenPostsInputProtocol {
    func updateFirstData(
        posts: [LemmyModel.PostView],
        comments: [LemmyModel.CommentView],
        subscribers: [LemmyModel.CommunityFollowerView]
    ) {
        self.viewController?.displayProfilePosts(
            viewModel: .init(state: .result(data: .init(posts: posts)))
        )
    }
    
    func registerSubmodule() { }
    
    func handleControllerAppearance() { }
}

class ProfileScreenPosts {
    enum PostsLoad {
        struct Request {
            let contentType: LemmySortType
        }

        struct ViewModel {
            let state: ViewControllerState
        }
    }
    
    enum NextProfilePostsLoad {
        struct Request {
            let contentType: LemmySortType
        }
        
        struct ViewModel {
            let state: PaginationState
        }
    }
    
    // MARK: States
    enum ViewControllerState {
        case loading
        case result(data: ProfileScreenPostsViewController.View.ViewData)
    }
    
    enum PaginationState {
        case result(data: [LemmyModel.PostView])
        case error(message: String)
    }
}
