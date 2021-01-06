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
    
    func doLoadMessages(request: InboxMessages.LoadMessages.Request) {

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
        case result([LemmyModel.UserMentionView])
        case loading
    }
}
