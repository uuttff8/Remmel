//
//  LoginCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/11/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class LoginCoordinator : Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController?

    init(navigationController :UINavigationController?) {
        self.navigationController = navigationController
    }

    func start() {

        let viewController = LoginViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

