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
    
    func goToCommunityScreen(communityId: Int) {
        let coordniator = CommunityScreenCoordinator(
            router: Router(navigationController: navigationController),
            communityId: communityId,
            communityInfo: nil
        )
        self.store(coordinator: coordniator)
        coordniator.start()
    }
}
