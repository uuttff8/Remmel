//
//  InboxRepliesAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol InboxRepliesInputProtocol: InboxNotificationSubmoduleProtocol { }

final class InboxRepliesAssembly: Assembly {
    
    var moduleInput: InboxRepliesInputProtocol?
    private let coordinator: WeakBox<InboxNotificationsCoordinator>
    
    init(coordinator: WeakBox<InboxNotificationsCoordinator>) {
        self.coordinator = coordinator
    }
    
    func makeModule() -> InboxRepliesViewController {
        let userAccService = UserAccountService()
        
        let viewModel = InboxRepliesViewModel(userAccountService: userAccService)
        let vc = InboxRepliesViewController(
            viewModel: viewModel,
            contentScoreService: ContentScoreService(
                userAccountService: userAccService
            ),
            showMoreService: ShowMoreHandlerService()
        )
        
        vc.coordinator = coordinator.value
        viewModel.viewController = vc
        self.moduleInput = viewModel
        return vc
    }
}
