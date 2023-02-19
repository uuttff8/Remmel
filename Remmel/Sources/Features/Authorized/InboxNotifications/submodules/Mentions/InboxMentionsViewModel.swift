//
//  InboxMentionsViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

protocol InboxMentionsViewModelProtocol {
    func doReceiveMessages()
    func doLoadMentions(request: InboxMentions.LoadMentions.Request)
    func doNextLoadMentions(request: InboxMentions.LoadMentions.Request)
}

final class InboxMentionsViewModel: InboxMentionsViewModelProtocol {
    weak var viewController: InboxMentionsViewControllerProtocol?
    
    private weak var wsClient: WSClientProtocol?
    private let userAccountService: UserAccountService
    
    private var paginationState = 1
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        userAccountService: UserAccountService,
        wsClient: WSClientProtocol
    ) {
        self.userAccountService = userAccountService
        self.wsClient = wsClient
    }
    
    func doReceiveMessages() {
        self.wsClient?.onTextMessage.addObserver(self, completionHandler: { [weak self] operation, data in
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
    
    func doLoadMentions(request: InboxMentions.LoadMentions.Request) {
        self.paginationState = 1
        
        guard let jwt = userAccountService.jwtToken else {
            Logger.common.error("No jwt token found")
            return
        }
        
        let params = LMModels.Api.Person.GetPersonMentions(sort: .hot,
                                                           page: paginationState,
                                                           limit: 50,
                                                           unreadOnly: false,
                                                           auth: jwt)
        
        ApiManager.requests.asyncGetPersonMentions(parameters: params)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                Logger.logCombineCompletion(completion)
            } receiveValue: { response in
                self.viewController?.displayMentions(viewModel: .init(state: .result(response.mentions)))
            }.store(in: &cancellables)
    }
    
    func doNextLoadMentions(request: InboxMentions.LoadMentions.Request) {
        self.paginationState += 1
        
        guard let jwt = userAccountService.jwtToken else {
            Logger.common.error("No jwt token found")
            return
        }
        
        let params = LMModels.Api.Person.GetPersonMentions(sort: .hot,
                                                           page: paginationState,
                                                           limit: 50,
                                                           unreadOnly: false,
                                                           auth: jwt)
        
        ApiManager.requests.asyncGetPersonMentions(parameters: params)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                Logger.logCombineCompletion(completion)
            } receiveValue: { response in
                self.viewController?.displayNextMentions(viewModel: .init(state: .result(response.mentions)))
            }.store(in: &cancellables)
    }
}

extension InboxMentionsViewModel: InboxMentionsInputProtocol {
    func update() {
        self.doLoadMentions(request: .init())
    }
    
    func handleControllerAppearance() { }
}

enum InboxMentions {
    enum LoadMentions {
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
        case result([LMModels.Views.PersonMentionView])
        case loading
    }
}
