//
//  InboxRepliesViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol InboxMessagesViewModelProtocol {
    func doLoadMessages(request: InboxMessages.LoadMessages.Request)
}

final class InboxMessagesViewModel: InboxMessagesViewModelProtocol {
    weak var viewController: InboxMessagesViewControllerProtocol?
    
    private let userAccountService: UserAccountService
    
    private var paginationState = 1
    
    init(
        userAccountService: UserAccountService
    ) {
        self.userAccountService = userAccountService
    }
    
    func doLoadMessages(request: InboxMessages.LoadMessages.Request) {
        guard let jwt = userAccountService.jwtToken else {
            Logger.commonLog.error("No jwt token is found")
            return
        }
        
//        let params = LemmyModel.User.
    }
}

extension InboxMessagesViewModel: InboxMessagesInputProtocol {
    func update() {
        self.doLoadMessages(request: .init())
    }
    
    func handleControllerAppearance() { }
}

enum InboxMessages {
    enum LoadMessages {
        struct Request { }
        struct ViewModel {
            let state: ViewControllerState
        }
    }
    
    enum ViewControllerState {
        case result([LemmyModel.PrivateMessageView])
        case loading
    }
}
