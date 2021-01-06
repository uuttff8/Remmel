//
//  InboxMentionsViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol InboxMentionsViewModelProtocol {
    func doLoadMentions(request: InboxMentions.LoadMentions.Request)
}

final class InboxMentionsViewModel: InboxMentionsViewModelProtocol {
    weak var viewController: InboxMentionsViewControllerProtocol?
    
    func doLoadMentions(request: InboxMentions.LoadMentions.Request) {
        
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
