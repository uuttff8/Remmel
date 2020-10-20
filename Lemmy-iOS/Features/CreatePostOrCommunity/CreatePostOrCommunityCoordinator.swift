//
//  CreatePostOrCommunityCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CreatePostOrCommunityCoordinator : Coordinator {
    var rootViewController: CreatePostOrCommunityViewController
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.rootViewController = CreatePostOrCommunityViewController()
        self.navigationController = navigationController
    }

    func start() {
        rootViewController.coordinator = self
    }
    
    func goToCreatePost() {
        let createPostCoord = CreatePostCoordinator(navigationController: nil)
        let newNavController = UINavigationController(rootViewController: createPostCoord.rootViewController)
        self.store(coordinator: createPostCoord)
        createPostCoord.start()
        
        rootViewController.present(newNavController, animated: true)
    }
}
