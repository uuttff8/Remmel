//
//  CommunitiesCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/14/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CommunitiesCoordinator: BaseCoordinator {
    var rootViewController: CommunitiesPreviewViewController
    var router: RouterProtocol?

    init(router: RouterProtocol?) {
        let assembly = CommunitiesPreviewAssembly()
        self.rootViewController = assembly.makeModule()
        super.init()
        self.router = router
        self.router?.viewController = self.rootViewController
    }

    override func start() {
        rootViewController.coordinator = self
    }
    
    func goToCommunityScreen(communityId: Int? = nil, communityName: String? = nil) {
        let coordinator = CommunityScreenCoordinator(
            router: Router(navigationController: navigationController),
            communityId: communityId,
            communityName: communityName
        )
        self.store(coordinator: coordinator)
        coordinator.start()
        self.router?.push(coordinator.rootViewController, isAnimated: true, onNavigateBack: {
            self.free(coordinator: coordinator)
        })
    }
}
