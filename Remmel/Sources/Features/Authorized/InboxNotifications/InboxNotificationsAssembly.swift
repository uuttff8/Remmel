//
//  InboxNotificationsAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

final class InboxNotificationsAssembly: Assembly {
    
    func makeModule() -> InboxNotificationsViewController {
        let viewModel = InboxNotificationsViewModel()
        let vc = InboxNotificationsViewController(viewModel: viewModel)
        
        viewModel.viewController = vc
        
        return vc
    }
}
