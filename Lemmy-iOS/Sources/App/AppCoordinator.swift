//
//  AppCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/11/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []

    var navigationController: UINavigationController?

    let window: UIWindow
    
    private let userAccountService = UserAccountService()

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        
        if userAccountService.isAuthorized {
            let myCoordinator = LemmyTabBarCoordinator()
            
            // store child coordinator
            self.store(coordinator: myCoordinator)
            myCoordinator.start()

            window.rootViewController = myCoordinator.rootViewController

        } else {
            let myCoordinator = InstancesCoordinator()
            
            // store child coordinator
            self.store(coordinator: myCoordinator)
            myCoordinator.start()

            window.rootViewController = myCoordinator.rootViewController

        }

        window.makeKeyAndVisible()
    }
}
