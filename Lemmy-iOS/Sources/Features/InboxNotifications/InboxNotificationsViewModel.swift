//
//  InboxNotificationsViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol InboxNotificationsViewModelProtocol {
    // Tab index -> Submodule
    var submodules: [Int: InboxNotificationSubmoduleProtocol] { get }
    var initialTabIndex: Int { get }
    var availableTabs: [InboxNotificationsViewModel.Submodule] { get }
    
    func doSubmoduleControllerAppearanceUpdate(request: InboxNotifications.SubmoduleAppearanceUpdate.Request)
    func doSubmodulesRegistration(request: InboxNotifications.SubmoduleRegistration.Request)
}

final class InboxNotificationsViewModel: InboxNotificationsViewModelProtocol {
    
    enum Submodule: CaseIterable {
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
    
    weak var viewController: InboxNotificationsViewControllerProtocol?
    
    private(set) var submodules: [Int: InboxNotificationSubmoduleProtocol] = [:]
    private(set) var initialTabIndex = 0
    private(set) var availableTabs: [Submodule] = [.replies, .mentions, .messages]
    
    func doSubmoduleControllerAppearanceUpdate(request: InboxNotifications.SubmoduleAppearanceUpdate.Request) {
        self.submodules[request.submoduleIndex]?.handleControllerAppearance()
    }
    
    func doSubmodulesRegistration(request: InboxNotifications.SubmoduleRegistration.Request) {
        for (key, value) in request.submodules {
            self.submodules[key] = value
        }
        self.pushCurrentCourseToSubmodules(submodules: Array(self.submodules.values))
    }
    
    private func pushCurrentCourseToSubmodules(submodules: [InboxNotificationSubmoduleProtocol]) {
        submodules.forEach { $0.update() }
    }
}

enum InboxNotifications {
    enum SubmoduleAppearanceUpdate {
        struct Request {
            let submoduleIndex: Int
        }
    }
    
    enum SubmoduleRegistration {
        struct Request {
            var submodules: [Int: InboxNotificationSubmoduleProtocol]
        }
    }
}
