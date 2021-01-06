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
    
    func makeModule() -> InboxMentionsViewController {
        let viewModel = InboxMentionsViewModel(userAccountService: UserAccountService())
        let vc = InboxMentionsViewController(viewModel: viewModel)
        
        viewModel.viewController = vc
        self.moduleInput = viewModel
        return vc
    }
}
