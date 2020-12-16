//
//  CommunitiesCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/14/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CommunitiesCoordinator: Coordinator {
    var rootViewController: CommunitiesPreviewViewController
    var childCoordinators: [Coordinator] = []

    var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        let assembly = CommunitiesPreviewAssembly()
        self.rootViewController = assembly.makeModule()
        self.navigationController = navigationController
    }

    func start() {
        rootViewController.coordinator = self
        navigationController?.pushViewController(self.rootViewController, animated: true)
    }
    
    func goToCommunityScreen(communityId: Int) {
        let assembly = CommunityScreenAssembly(communityId: communityId, communityInfo: nil)
        let module = assembly.makeModule()
        self.navigationController?.pushViewController(module, animated: true)
    }
}
