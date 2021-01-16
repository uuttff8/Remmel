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
    func doLoadReplies(request: InboxReplies.LoadReplies.Request)
    func doNextLoadReplies(request: InboxReplies.LoadReplies.Request)
}

final class InboxRepliesViewModel: InboxRepliesViewModelProtocol {
    weak var viewController: InboxRepliesViewControllerProtocol?
    
    private let userAccountService: UserAccountSerivceProtocol
    
    private var paginationState = 1
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        userAccountService: UserAccountSerivceProtocol
    ) {
        self.userAccountService = userAccountService
    }
    
    func doLoadReplies(request: InboxReplies.LoadReplies.Request) {
        self.paginationState = 1
        
        guard let jwt = userAccountService.jwtToken else {
            Logger.commonLog.error("No jwt token found")
            return
        }
        
        let params = LMModels.Api.User.GetReplies(sort: .active,
                                                  page: paginationState,
                                                  limit: 50,
                                                  unreadOnly: false,
                                                  auth: jwt)
        
        ApiManager.requests.asyncGetReplies(parameters: params)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
            } receiveValue: { (response) in
                self.viewController?.displayReplies(viewModel: .init(state: .result(response.replies)))
            }.store(in: &cancellables)
    }
    
    func doNextLoadReplies(request: InboxReplies.LoadReplies.Request) {
        self.paginationState += 1
        
        guard let jwt = userAccountService.jwtToken else {
            Logger.commonLog.error("No jwt token found")
            return
        }
        
        let params = LMModels.Api.User.GetReplies(sort: .active,
                                                       page: paginationState,
                                                       limit: 50,
                                                       unreadOnly: false,
                                                       auth: jwt)
        
        ApiManager.requests.asyncGetReplies(parameters: params)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
            } receiveValue: { (response) in
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
    
    enum ViewControllerState {
        case result([LMModels.Views.CommentView])
        case loading
    }
}
