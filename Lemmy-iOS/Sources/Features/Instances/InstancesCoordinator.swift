//
//  InstancesCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 19.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class InstancesCoordinator: GenericCoordinator<UINavigationController> {
    
    init() {
        let navController = StyledNavigationController(rootViewController: InstancesViewController())
        
        super.init(navigationController: navController)
        self.rootViewController = navigationController
    }
    
    // TODO: rewrite
    override func start() {
        if let vc =  rootViewController.topViewController as? InstancesViewController {
            vc.coordinator = self
        }
    }
}
