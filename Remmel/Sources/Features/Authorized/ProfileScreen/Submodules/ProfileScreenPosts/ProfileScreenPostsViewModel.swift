//
//  ProfileScreenPostsViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine
import RMModels
import RMFoundation
import RMNetworking

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
        
        let params = RMModel.Api.Person.GetPersonDetails(personId: loadedProfile?.id,
                                                          username: loadedProfile?.viewData.name,
                                                          sort: request.sortType,
                                                          page: paginationState.page,
                                                          limit: 50,
                                                          communityId: nil,
                                                          savedOnly: false,
                                                          auth: LemmyShareData.shared.jwtToken)
        
        ApiManager.requests.asyncGetUserDetails(parameters: params)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                debugPrint(completion)
            } receiveValue: { [weak self] response in
                
                self?.viewController?.displayProfilePosts(
                    viewModel: .init(state: .result(data: .init(posts: response.posts)))
                )
                
            }.store(in: &cancellable)
    }
    
    func doNextPostsFetch(request: ProfileScreenPosts.NextProfilePostsLoad.Request) {
        self.paginationState.page += 1
        
        let params = RMModel.Api.Person.GetPersonDetails(personId: loadedProfile?.id,
                                                          username: loadedProfile?.viewData.name,
                                                          sort: request.sortType,
                                                          page: paginationState.page,
                                                          limit: 50,
                                                          communityId: nil,
                                                          savedOnly: false,
                                                          auth: LemmyShareData.shared.jwtToken)
        
        ApiManager.requests.asyncGetUserDetails(parameters: params)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                debugPrint(completion)
            } receiveValue: { [weak self] response in
                
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
        posts: [RMModel.Views.PostView]
    ) {
        self.loadedProfile = profile
        self.viewController?.displayProfilePosts(
            viewModel: .init(state: .result(data: .init(posts: posts)))
        )
    }
    
    func registerSubmodule() { }
    
    func handleControllerAppearance() { }
}

enum ProfileScreenPosts {
    enum PostsLoad {
        struct Request {
            let sortType: RMModel.Others.SortType
        }
        
        struct ViewModel {
            let state: ViewControllerState
        }
    }
    
    enum NextProfilePostsLoad {
        struct Request {
            let sortType: RMModel.Others.SortType
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
        case result(data: [RMModel.Views.PostView])
        case error(message: String)
    }
}
