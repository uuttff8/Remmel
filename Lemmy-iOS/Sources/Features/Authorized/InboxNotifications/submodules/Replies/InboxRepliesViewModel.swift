//
//  InboxRepliesViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

protocol InboxRepliesViewModelProtocol {
    func doReceiveMessages()
    func doLoadReplies(request: InboxReplies.LoadReplies.Request)
    func doNextLoadReplies(request: InboxReplies.LoadReplies.Request)
}

final class InboxRepliesViewModel: InboxRepliesViewModelProtocol {
    weak var viewController: InboxRepliesViewControllerProtocol?
    
    private weak var wsClient: WSClientProtocol?
    private let userAccountService: UserAccountSerivceProtocol
    
    private var paginationState = 1
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        userAccountService: UserAccountSerivceProtocol,
        wsClient: WSClientProtocol
    ) {
        self.userAccountService = userAccountService
        self.wsClient = wsClient
    }
    
    func doReceiveMessages() {
        self.wsClient?.onTextMessage.addObserver(self, completionHandler: {
            [weak self] operation, data in
            
            guard let self = self else {
                return
            }
            
            switch operation {
            case LMMUserOperation.CreateCommentLike.rawValue:
                guard let like = self.wsClient?.decodeWsType(
                    LMModels.Api.Comment.CommentResponse.self,
                    data: data
                ) else { return }
                
                DispatchQueue.main.async {
                    self.viewController?.displayCreateCommentLike(viewModel: .init(commentView: like.commentView))
                }
            default: break
            }
        })
    }
    
    func doLoadReplies(request: InboxReplies.LoadReplies.Request) {
        self.paginationState = 1
        
        guard let jwt = userAccountService.jwtToken else {
            Logger.common.error("No jwt token found")
            return
        }
        
        let params = LMModels.Api.Person.GetReplies(
            sort: .active,
            page: paginationState,
            limit: 50,
            unreadOnly: false,
            auth: jwt
        )
        
        ApiManager.requests.asyncGetReplies(parameters: params)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                Logger.logCombineCompletion(completion)
            } receiveValue: { response in
                self.viewController?.displayReplies(viewModel: .init(state: .result(response.replies)))
            }.store(in: &cancellables)
    }
    
    func doNextLoadReplies(request: InboxReplies.LoadReplies.Request) {
        self.paginationState += 1
        
        guard let jwt = userAccountService.jwtToken else {
            Logger.common.error("No jwt token found")
            return
        }
        
        let params = LMModels.Api.Person.GetReplies(
            sort: .active,
            page: paginationState,
            limit: 50,
            unreadOnly: false,
            auth: jwt
        )
        
        ApiManager.requests.asyncGetReplies(parameters: params)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                Logger.logCombineCompletion(completion)
            } receiveValue: { response in
                self.viewController?.displayNextReplies(viewModel: .init(state: .result(response.replies)))
            }.store(in: &cancellables)
    }
}

extension InboxRepliesViewModel: InboxRepliesInputProtocol {
    func update() {
        self.doLoadReplies(request: .init())
    }
    
    func handleControllerAppearance() { }
}

enum InboxReplies {
    enum LoadReplies {
        struct Request { }
        struct ViewModel {
            let state: ViewControllerState
        }
    }
    
    enum CreateCommentLike {
        struct ViewModel {
            let commentView: LMModels.Views.CommentView
        }
    }
    
    enum ViewControllerState {
        case result([LMModels.Views.CommentView])
        case loading
    }
}
