//
//  InstancesCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 19.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class InstancesCoordinator: GenericCoordinator<InstancesViewController> {
    
    override init(navigationController: UINavigationController?) {
        super.init(navigationController: navigationController)
        let assembly = InstancesAssembly()
        self.rootViewController = assembly.makeModule()
    }
    
    override func start() {
        rootViewController.coordinator = self
        navigationController?.pushViewController(rootViewController, animated: true)
    }
}
