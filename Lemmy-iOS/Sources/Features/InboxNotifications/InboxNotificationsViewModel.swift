//
//  InboxNotificationsViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol InboxNotificationsViewModelProtocol {
    var submodules: [InboxNotificationsViewModel.InboxSubmodule] { get }
}

final class InboxNotificationsViewModel: InboxNotificationsViewModelProtocol {
    
    enum InboxSubmodule: CaseIterable {
        case replies
        case mentions
        case messages
        
        var title: String {
            switch self {
            case .replies: return "Replies"
            case .mentions: return "Mentions"
            case .messages: return "Messages"
            }
        }
    }
    
    private(set) var submodules: [InboxSubmodule] = [.replies, .mentions, .messages]
}
