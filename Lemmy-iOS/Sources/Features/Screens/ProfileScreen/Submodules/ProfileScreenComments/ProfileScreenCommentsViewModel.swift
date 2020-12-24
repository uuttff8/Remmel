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
    func doProfileCommentsFetch()
    func doNextCommentsFetch(request: ProfileScreenComments.NextProfileCommentsLoad.Request)
}

class ProfileScreenCommentsViewModel: ProfileScreenCommentsViewModelProtocol {
    weak var viewController: ProfileScreenCommentsViewControllerProtocol?
    
    typealias PaginationState = (page: Int, hasNext: Bool)
    private var paginationState = PaginationState(page: 1, hasNext: true)

    var cancellable = Set<AnyCancellable>()
    
    func doProfileCommentsFetch() { }
    
    func doNextCommentsFetch(request: ProfileScreenComments.NextProfileCommentsLoad.Request) {
        self.paginationState.page += 1
        
        let params = LemmyModel.Comment.GetCommentsRequest(type: .all,
                                                           sort: request.contentType,
                                                           page: paginationState.page,
                                                           limit: 50,
                                                           auth: LemmyShareData.shared.jwtToken)
        
        ApiManager.requests.asyncGetComments(parameters: params)
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
        posts: [LemmyModel.PostView],
        comments: [LemmyModel.CommentView],
        subscribers: [LemmyModel.CommunityFollowerView]
    ) {
        self.viewController?.displayProfileComments(
            viewModel: .init(state: .result(data: .init(comments: comments)))
        )
    }
    
    func registerSubmodule() { }
    
    func handleControllerAppearance() { }
}

enum ProfileScreenComments {
    enum CommentsLoad {
        struct Response {
            let comments: [LemmyModel.CommentView]
        }
        
        struct ViewModel {
            let state: ViewControllerState
        }
    }
    
    enum NextProfileCommentsLoad {
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
        case result(data: ProfileScreenCommentsViewController.View.ViewData)
    }
    
    enum PaginationState {
        case result(data: [LemmyModel.CommentView])
        case error(message: String)
    }
}
