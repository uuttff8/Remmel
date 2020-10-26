//
//  CreatePostCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 20.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CreatePostCoordinator : Coordinator {
    var rootViewController: CreatePostScreenViewController
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.rootViewController = CreatePostScreenViewController()
        self.navigationController = navigationController
        
        self.navigationController?.setViewControllers([rootViewController], animated: true)
    }

    func start() {
        rootViewController.coordinator = self
        navigationController?.presentationController?.delegate = rootViewController
    }
    
    func goToChoosingCommunity(model: CreatePostScreenModel) {
        let choosingVc = ChooseCommunityViewController(model: model)
        choosingVc.coordinator = self
        navigationController?.pushViewController(choosingVc, animated: true)
    }
}
