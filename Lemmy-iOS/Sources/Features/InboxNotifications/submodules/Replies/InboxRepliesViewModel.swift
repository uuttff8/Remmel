//
//  InboxRepliesViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol InboxRepliesViewModelProtocol {
    func doLoadReplies(request: InboxReplies.LoadReplies.Request)
    func doNextLoadReplies(request: InboxReplies.LoadReplies.Request)
}

final class InboxRepliesViewModel: InboxRepliesViewModelProtocol {
    weak var viewController: InboxRepliesViewControllerProtocol?
    
    private let userAccountService: UserAccountSerivceProtocol
    
    private var paginationState = 1
    
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
    }
    
    func doNextLoadReplies(request: InboxReplies.LoadReplies.Request) {
        self.paginationState += 1
        
        guard let jwt = userAccountService.jwtToken else {
            Logger.commonLog.error("No jwt token found")
            return
        }
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
        case result([LemmyModel.ReplyView])
        case loading
    }
}
