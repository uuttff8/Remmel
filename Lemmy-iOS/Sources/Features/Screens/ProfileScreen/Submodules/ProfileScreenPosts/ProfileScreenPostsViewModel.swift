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
    func doProfilePostsFetch()
}

class ProfileScreenPostsViewModel: ProfileScreenPostsViewModelProtocol {
    private var currentProfile: LemmyModel.UserView?
    
    weak var viewController: ProfileScreenPostViewControllerProtocol?
    
    var cancellable = Set<AnyCancellable>()
    
    func doProfilePostsFetch() {
        let params = LemmyModel.Post.GetPostsRequest(type: .all,
                                                     sort: .active,
                                                     page: 1,
                                                     limit: 50,
                                                     communityId: nil,
                                                     communityName: nil,
                                                     auth: LemmyShareData.shared.jwtToken)
        
        ApiManager.requests.asyncGetPosts(parameters: params)
            .receive(on: RunLoop.main)
            .sink { (error) in
                print(error)
            } receiveValue: { (response) in
                self.viewController?
                    .displayProfilePosts(
                        viewModel: .init(state: .result(data: .init(posts: response.posts)))
                    )
            }.store(in: &cancellable)
        
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
        struct Response {
            let posts: [LemmyModel.PostView]
        }
        
        struct ViewModel {
            let state: ViewControllerState
        }
    }
    
    // MARK: States
    enum ViewControllerState {
        case loading
        case result(data: ProfileScreenPostsViewController.View.ViewData)
    }
}
