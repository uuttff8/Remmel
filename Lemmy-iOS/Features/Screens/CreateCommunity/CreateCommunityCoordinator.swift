//
//  CreateCommunityCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 28.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CreateCommunityCoordinator : Coordinator {
    var rootViewController: CreateCommunityViewController
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.rootViewController = CreateCommunityViewController()
        self.navigationController = navigationController
        
        self.navigationController?.setViewControllers([rootViewController], animated: true)
    }

    func start() {
        rootViewController.coordinator = self
        navigationController?.presentationController?.delegate = rootViewController
    }
}
