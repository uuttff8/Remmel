//
//  CreateCommunityCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 28.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

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

    func goToChoosingCommunity() {
//        let choosingVc = ChooseCategoryViewController(model: model)
//        choosingVc.coordinator = self
//        navigationController?.pushViewController(choosingVc, animated: true)
    }

    func goToCommunity(comm: LemmyModel.CommunityView) {
        // TODO(uuttff8): see fatal error
        fatalError("Please implement community view")
    }
}
