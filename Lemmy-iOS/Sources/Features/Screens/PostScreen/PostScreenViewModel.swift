//
//  PostScreenModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/2/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

protocol PostScreenViewModelProtocol: AnyObject {
    func doPostFetch()
    func doReceiveMessages()
}

class PostScreenViewModel: PostScreenViewModelProtocol {
    weak var viewController: PostScreenViewControllerProtocol?
    
    private weak var wsClient: WSClientProtocol?
    
    private var cancellable = Set<AnyCancellable>()
    
    let postInfo: LMModels.Views.PostView?
    let postId: Int
    
    init(
        postId: Int,
        postInfo: LMModels.Views.PostView?,
        wsClient: WSClientProtocol?
    ) {
        self.postInfo = postInfo
        self.postId = postId
        self.wsClient = wsClient
    }
    
    func doPostFetch() {
        let parameters = LMModels.Api.Post.GetPost(id: postId,
                                                   auth: LemmyShareData.shared.jwtToken)
        
        ApiManager.requests.asyncGetPost(parameters: parameters)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
            } receiveValue: { [weak self] (response) in
                guard let self = self else { return }
                self.viewController?.displayPost(
                    viewModel: .init(
                        state: .result(
                            data: self.makeViewData(from: response)
                        )
                    )
                )
            }.store(in: &cancellable)
    }
    
    func doReceiveMessages() {
        wsClient?
            .onMessage(completion: { (operation, data) in
                
            })
    }
    
    private func makeViewData(
        from data: LMModels.Api.Post.GetPostResponse
    ) -> PostScreenViewController.View.ViewData {
        let comments = CommentListingSort(comments: data.comments)
            .createCommentsTree()
        
        return .init(post: data.postView, comments: comments)
    }
}

enum PostScreen {
    
    enum PostLoad {
        
        struct Response {
            let postId: ViewControllerState
        }
        
        struct ViewModel {
            let state: ViewControllerState
        }
    }
    
    enum SavePost {
        struct Request { }
        
        struct ViewModel {
            let post: LMModels.Views.PostView
        }
    }
    
    enum SaveComment {
        struct Request { }
        
        struct ViewModel {
            let comment: LMModels.Views.CommentView
        }
    }
    
    // States
    enum ViewControllerState {
        case loading
        case result(data: PostScreenViewController.View.ViewData)
    }
}
