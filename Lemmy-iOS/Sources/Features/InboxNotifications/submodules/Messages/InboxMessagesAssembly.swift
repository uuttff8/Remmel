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
    
    func makeModule() -> InboxMessagesViewController {
        let viewModel = InboxMessagesViewModel()
        let vc = InboxMessagesViewController(viewModel: viewModel)
        
        viewModel.viewController = vc
        self.moduleInput = viewModel
        return vc
    }
}

