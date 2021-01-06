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
    
    func makeModule() -> InboxRepliesViewController {
        let viewModel = InboxRepliesViewModel(userAccountService: UserAccountService())
        let vc = InboxRepliesViewController(viewModel: viewModel)
        
        viewModel.viewController = vc
        self.moduleInput = viewModel
        return vc
    }
}
