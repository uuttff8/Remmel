//
//  InboxNotificationsCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

final class InboxNotificationsCoordinator: GenericCoordinator<InboxNotificationsViewController> {
    
    init(router: Router?) {
        super.init(router: router)
        let assembly = InboxNotificationsAssembly()
        self.rootViewController = assembly.makeModule()
        self.router?.viewController = self.rootViewController
    }
    
    override func start() {
        rootViewController.coordinator = self
    }
}
