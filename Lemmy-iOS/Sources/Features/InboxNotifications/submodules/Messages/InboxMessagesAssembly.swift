//
//  InboxMessagesAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

protocol InboxMessagesInputProtocol: InboxNotificationSubmoduleProtocol { }

final class InboxMessagesAssembly: Assembly {
    
    var moduleInput: InboxMessagesInputProtocol?
    private let coordinator: WeakBox<InboxNotificationsCoordinator>
    
    init(coordinator: WeakBox<InboxNotificationsCoordinator>) {
        self.coordinator = coordinator
    }
    
    func makeModule() -> InboxMessagesViewController {
        let viewModel = InboxMessagesViewModel(userAccountService: UserAccountService())
        let vc = InboxMessagesViewController(viewModel: viewModel)
        
        vc.coordinator = coordinator.value
        viewModel.viewController = vc
        self.moduleInput = viewModel
        return vc
    }
}
