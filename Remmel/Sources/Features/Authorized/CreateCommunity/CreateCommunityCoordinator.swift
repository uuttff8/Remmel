//
//  CreateCommunityCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 28.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMModels

class CreateCommunityCoordinator: Coordinator {
    var rootViewController: CreateCommunityViewController
    var childCoordinators: [Coordinator] = []

    var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        let assembly = CreateCommunityAssembly()
        self.rootViewController = assembly.makeModule()
        self.navigationController = navigationController

        self.navigationController?.setViewControllers([rootViewController], animated: true)
    }

    func start() {
        rootViewController.coordinator = self
        navigationController?.presentationController?.delegate = rootViewController
    }

    func goToCommunity(comm: RMModels.Views.CommunityView) {
        self.rootViewController.dismiss(animated: true)
        
        if let presentingVc = rootViewController.presentingViewController as? LemmyTabBarController {
            presentingVc.coordinator?.goToCommunity(community: comm)
        }
    }
}
