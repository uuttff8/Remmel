//
//  InboxMentionsAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol InboxMentionsInputProtocol: InboxNotificationSubmoduleProtocol { }

final class InboxMentionsAssembly: Assembly {
    
    var moduleInput: InboxMentionsInputProtocol?
    private let coordinator: WeakBox<InboxNotificationsCoordinator>
    
    init(coordinator: WeakBox<InboxNotificationsCoordinator>) {
        self.coordinator = coordinator
    }
    
    func makeModule() -> InboxMentionsViewController {
        let userAccService = UserAccountService()
        
        let viewModel = InboxMentionsViewModel(userAccountService: userAccService, wsClient: ApiManager.chainedWsCLient)
        let vc = InboxMentionsViewController(
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
