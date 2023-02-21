//
//  AppCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/11/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMServices

class AppCoordinator {
    
    private let window: UIWindow
    private let currentAccountService: UserAccountServiceProtocol
    private var childCoordinators = [Coordinator]()
    
    init(window: UIWindow, currentAccountService: UserAccountServiceProtocol) {
        self.window = window
        self.currentAccountService = currentAccountService
    }
    
    func start() {
        if currentAccountService.isAuthorized {
            let tabBarCoordinator = LemmyTabBarCoordinator()
            childCoordinators.append(tabBarCoordinator)
            tabBarCoordinator.start()

            window.rootViewController = tabBarCoordinator.rootViewController
        } else {
            let instancesCoordinator = InstancesCoordinator(router: Router(navigationController: StyledNavigationController()))
            childCoordinators.append(instancesCoordinator)
            instancesCoordinator.start()
            instancesCoordinator.router.setRoot(instancesCoordinator, isAnimated: true)
            
            window.rootViewController = instancesCoordinator.router.navigationController
        }
    }
}
