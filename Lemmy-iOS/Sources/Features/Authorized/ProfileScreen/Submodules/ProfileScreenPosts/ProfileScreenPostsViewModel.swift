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
    func doPostFetch(request: ProfileScreenPosts.NextProfilePostsLoad.Request)
    func doNextPostsFetch(request: ProfileScreenPosts.NextProfilePostsLoad.Request)
}

class ProfileScreenPostsViewModel: ProfileScreenPostsViewModelProtocol {
    typealias PaginationState = (page: Int, hasNext: Bool)
    
    weak var viewController: ProfileScreenPostViewControllerProtocol?
    
    private var loadedProfile: ProfileScreenViewModel.ProfileData?
    
    private var paginationState = PaginationState(page: 1, hasNext: true)
    private var cancellable = Set<AnyCancellable>()
    
    func doPostFetch(request: ProfileScreenPosts.NextProfilePostsLoad.Request) {
        self.paginationState.page = 1
        
        let params = LMModels.Api.Person.GetPersonDetails(personId: loadedProfile?.id,
                                                          username: loadedProfile?.viewData.name,
                                                          sort: request.sortType,
                                                          page: paginationState.page,
                                                          limit: 50,
                                                          communityId: nil,
                                                          savedOnly: false,
                                                          auth: LemmyShareData.shared.jwtToken)
        
        ApiManager.requests.asyncGetUserDetails(parameters: params)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.common.info(completion)
            } receiveValue: { [weak self] (response) in
                
                self?.viewController?.displayProfilePosts(
                    viewModel: .init(state: .result(data: .init(posts: response.posts)))
                )
                
            }.store(in: &cancellable)
    }
    
    func doNextPostsFetch(request: ProfileScreenPosts.NextProfilePostsLoad.Request) {
        self.paginationState.page += 1
        
        let params = LMModels.Api.Person.GetPersonDetails(personId: loadedProfile?.id,
                                                          username: loadedProfile?.viewData.name,
                                                          sort: request.sortType,
                                                          page: paginationState.page,
                                                          limit: 50,
                                                          communityId: nil,
                                                          savedOnly: false,
                                                          auth: LemmyShareData.shared.jwtToken)
        
        ApiManager.requests.asyncGetUserDetails(parameters: params)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.common.info(completion)
            } receiveValue: { [weak self] (response) in
                
                self?.viewController?.displayNextPosts(
                    viewModel: .init(
                        state: .result(data: response.posts)
                    )
                )
                
            }.store(in: &cancellable)
    }
}

extension ProfileScreenPostsViewModel: ProfileScreenPostsInputProtocol {
    func updatePostsData(
        profile: ProfileScreenViewModel.ProfileData,
        posts: [LMModels.Views.PostView]
    ) {
        self.loadedProfile = profile
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
            let sortType: LMModels.Others.SortType
        }
        
        struct ViewModel {
            let state: ViewControllerState
        }
    }
    
    enum NextProfilePostsLoad {
        struct Request {
            let sortType: LMModels.Others.SortType
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
        case result(data: [LMModels.Views.PostView])
        case error(message: String)
    }
}
