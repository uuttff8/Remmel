//
//  LemmyTabBarCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/11/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class LemmyTabBarCoordinator: Coordinator {
    var rootViewController: LemmyTabBarController
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController? = {
       return nil
    }()
    
    init() {
        self.rootViewController = LemmyTabBarController()
    }
        
    func start() {
        rootViewController.coordinator = self
        rootViewController.createTabs()
    }
    
    func goToCreateOrPostScreen() {
        let createPostOrCommCoordinator = CreatePostOrCommunityCoordinator(navigationController: nil)
        self.store(coordinator: createPostOrCommCoordinator)
        createPostOrCommCoordinator.start()
        rootViewController.present(createPostOrCommCoordinator.rootViewController, animated: true, completion: nil)
    }
    
    func goToLoginScreen(authMethod: LemmyAuthMethod) {
        let loginCoordinator = LoginCoordinator(navigationController: nil, authMethod: authMethod)
        self.store(coordinator: loginCoordinator)
        loginCoordinator.start()
        
        rootViewController.present(loginCoordinator.rootViewController, animated: true, completion: nil)
    }
}
