//
//  CommunityScreenCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 18.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CommunityScreenCoordinator: GenericCoordinator<CommunityScreenViewController> {
    
    init(navigationController: UINavigationController?, communityId: Int, communityInfo: LemmyModel.CommunityView?) {
        super.init(navigationController: navigationController)
        let assembly = CommunityScreenAssembly(communityId: communityId, communityInfo: communityInfo)
        self.rootViewController = assembly.makeModule()
    }

    override func start() {
        rootViewController.coordinator = self
        navigationController?.pushViewController(self.rootViewController, animated: true)
    }
}
