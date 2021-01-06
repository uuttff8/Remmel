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
}

final class InboxRepliesViewModel: InboxRepliesViewModelProtocol {
    weak var viewController: InboxRepliesViewControllerProtocol?
    
    func doLoadReplies(request: InboxReplies.LoadReplies.Request) {

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
        case result([LemmyModel.UserMentionView])
        case loading
    }
}
