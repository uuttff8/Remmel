//
//  LoginCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/11/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class LoginCoordinator : Coordinator {
    var rootViewController: LoginViewController
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController?

    init(navigationController: UINavigationController, authMethod: LemmyAuthMethod) {
        self.rootViewController = LoginViewController(authMethod: authMethod)
        self.navigationController = navigationController
    }

    func start() {
        navigationController?.pushViewController(rootViewController, animated: true)
    }
}

