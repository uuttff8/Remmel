//
//  CreatePostOrCommunityCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CreatePostOrCommunityCoordinator: Coordinator {
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
