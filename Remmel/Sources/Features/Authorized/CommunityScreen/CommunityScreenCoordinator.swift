//
//  CommunityScreenCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 18.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CommunityScreenCoordinator: GenericCoordinator<CommunityScreenViewController> {
    
    init(router: RouterProtocol?, communityId: Int?, communityName: String?) {
        assert(communityId != nil || communityName != nil, "One of these arguments should not be nil")
        
        super.init(router: router)
        let assembly = CommunityScreenAssembly(communityId: communityId, communityName: communityName)
        self.rootViewController = assembly.makeModule()
        self.router?.viewController = self.rootViewController
    }

    override func start() {
        rootViewController.coordinator = self
    }
}
