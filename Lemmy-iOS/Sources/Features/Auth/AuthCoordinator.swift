//
//  LoginCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/11/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class LoginCoordinator: BaseCoordinator {
    var rootViewController: LoginViewController

    let router: RouterProtocol
    
    init(router: RouterProtocol, authMethod: LemmyAuthMethod) {
        self.rootViewController = LoginViewController(authMethod: authMethod)
        self.router = router
        self.router.viewController = self.rootViewController
    }

    override func start() {
        self.rootViewController.coordinator = self
    }
}
