//
//  CreatePostOrCommunityCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CreateMediaCoordinator: Coordinator {
    var rootViewController: CreateMediaViewController
    var childCoordinators: [Coordinator] = []

    var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.rootViewController = CreateMediaViewController()
        self.navigationController = navigationController
    }

    func start() {
        rootViewController.coordinator = self
    }

    func goToCreatePost() {
        rootViewController.dismissView()
        if let presentingVc = rootViewController.presentingViewController as? LemmyTabBarController {
            presentingVc.coordinator?.goToCreatePost()
        }
    }

    func goToCreateCommunity() {
        rootViewController.dismissView()
        if let presentingVc = rootViewController.presentingViewController as? LemmyTabBarController {
            presentingVc.coordinator?.goToCreateCommunity()
        }
    }
}
