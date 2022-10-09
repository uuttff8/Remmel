//
//  AppCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/11/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class AppCoordinator: BaseCoordinator {
    
    private let window: UIWindow
    private let windowScene: UIWindowScene
    
    private let userAccountService: UserAccountSerivceProtocol
    
    init(window: UIWindow, windowScene: UIWindowScene, userAccountService: UserAccountSerivceProtocol) {
        self.window = window
        self.windowScene = windowScene
        self.userAccountService = userAccountService
    }
    
    override func start() {
        
        if userAccountService.isAuthorized {
            let myCoordinator = LemmyTabBarCoordinator()
            self.store(coordinator: myCoordinator)
            myCoordinator.start()

            window.rootViewController = myCoordinator.rootViewController
        } else {
            let myCoordinator = InstancesCoordinator(router: Router(navigationController: StyledNavigationController()))
            self.store(coordinator: myCoordinator)
            myCoordinator.start()
            myCoordinator.router.setRoot(myCoordinator, isAnimated: true)
            
            window.rootViewController = myCoordinator.router.navigationController
        }
        
        window.windowScene = windowScene
        window.makeKeyAndVisible()
    }
}
