//
//  ProfileScreenCommentsViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 11.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

protocol ProfileScreenCommentsViewModelProtocol {
    // TODO do pagination
    func doProfileCommentsFetch(request: ProfileScreenComments.CommentsLoad.Request)
    func doNextCommentsFetch(request: ProfileScreenComments.NextProfileCommentsLoad.Request)
}

class ProfileScreenCommentsViewModel: ProfileScreenCommentsViewModelProtocol {
    typealias PaginationState = (page: Int, hasNext: Bool)
    
    weak var viewController: ProfileScreenCommentsViewControllerProtocol?
    
    private var paginationState = PaginationState(page: 1, hasNext: true)
    
    private var loadedProfile: LemmyModel.UserView?

    var cancellable = Set<AnyCancellable>()
    
    func doProfileCommentsFetch(request: ProfileScreenComments.CommentsLoad.Request) {
        self.paginationState.page = 1
        
        let params = LemmyModel.User.GetUserDetailsRequest(userId: loadedProfile?.id,
                                                           username: loadedProfile?.name,
                                                           sort: request.sortType,
                                                           page: paginationState.page,
                                                           limit: 50,
                                                           communityId: nil,
                                                           savedOnly: false,
                                                           auth: LemmyShareData.shared.jwtToken)

        ApiManager.requests.asyncGetUserDetails(parameters: params)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
            } receiveValue: { [weak self] (response) in
                
                self?.viewController?.displayNextComments(
                    viewModel: .init(
                        state: .result(data: response.comments)
                    )
                )
                
            }.store(in: &cancellable)
    }
    
    func doNextCommentsFetch(request: ProfileScreenComments.NextProfileCommentsLoad.Request) {
        self.paginationState.page += 1
        
        let params = LemmyModel.User.GetUserDetailsRequest(userId: loadedProfile?.id,
                                                           username: loadedProfile?.name,
                                                           sort: request.sortType,
                                                           page: paginationState.page,
                                                           limit: 50,
                                                           communityId: nil,
                                                           savedOnly: false,
                                                           auth: LemmyShareData.shared.jwtToken)

        ApiManager.requests.asyncGetUserDetails(parameters: params)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
            } receiveValue: { [weak self] (response) in
                
                self?.viewController?.displayNextComments(
                    viewModel: .init(
                        state: .result(data: response.comments)
                    )
                )
                
            }.store(in: &cancellable)
    }
}

extension ProfileScreenCommentsViewModel: ProfileScreenCommentsInputProtocol {
    func updateFirstData(
        profile: LemmyModel.UserView,
        posts: [LemmyModel.PostView],
        comments: [LemmyModel.CommentView],
        subscribers: [LemmyModel.CommunityFollowerView]
    ) {
        self.loadedProfile = profile
        self.viewController?.displayProfileComments(
            viewModel: .init(state: .result(data: .init(comments: comments)))
        )
    }
    
    func registerSubmodule() { }
    
    func handleControllerAppearance() { }
}

enum ProfileScreenComments {
    enum CommentsLoad {
        struct Request {
            let sortType: LemmySortType
        }
        
        struct ViewModel {
            let state: ViewControllerState
        }
    }
    
    enum NextProfileCommentsLoad {
        struct Request {
            let sortType: LemmySortType
        }
        
        struct ViewModel {
            let state: PaginationState
        }
    }
    
    // MARK: States
    enum ViewControllerState {
        case loading
        case result(data: ProfileScreenCommentsViewController.View.ViewData)
    }
    
    enum PaginationState {
        case result(data: [LemmyModel.CommentView])
        case error(message: String)
    }
}
