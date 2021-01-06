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
    func doLoadMentions(request: InboxMentions.LoadMentions.Request)
    func doNextLoadMentions(request: InboxMentions.LoadMentions.Request)
}

final class InboxMentionsViewModel: InboxMentionsViewModelProtocol {
    weak var viewController: InboxMentionsViewControllerProtocol?
    
    private let userAccountService: UserAccountService
    
    private var paginationState = 1
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        userAccountService: UserAccountService
    ) {
        self.userAccountService = userAccountService
    }
    
    func doLoadMentions(request: InboxMentions.LoadMentions.Request) {
        self.paginationState = 1
        
        guard let jwt = userAccountService.jwtToken else {
            Logger.commonLog.error("No jwt token found")
            return
        }
        
        let params = LemmyModel.User.GetUserMentionsRequest(sort: .active,
                                                            page: paginationState,
                                                            limit: 50,
                                                            unreadOnly: false,
                                                            auth: jwt)
        
        ApiManager.requests.asyncGetUserMentions(parameters: params)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
            } receiveValue: { (response) in
                self.viewController?.displayMentions(viewModel: .init(state: .result(response.mentions)))
            }.store(in: &cancellables)
    }
    
    func doNextLoadMentions(request: InboxMentions.LoadMentions.Request) {
        self.paginationState += 1
        
        guard let jwt = userAccountService.jwtToken else {
            Logger.commonLog.error("No jwt token found")
            return
        }
        
        let params = LemmyModel.User.GetUserMentionsRequest(sort: .active,
                                                            page: paginationState,
                                                            limit: 50,
                                                            unreadOnly: false,
                                                            auth: jwt)
        
        ApiManager.requests.asyncGetUserMentions(parameters: params)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
            } receiveValue: { (response) in
                self.viewController?.displayMentions(viewModel: .init(state: .result(response.mentions)))
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
    
    enum ViewControllerState {
        case result([LemmyModel.UserMentionView])
        case loading
    }
}
