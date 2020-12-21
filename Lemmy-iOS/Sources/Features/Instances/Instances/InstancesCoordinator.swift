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
        let assembly = InstancesAssembly()
        let navController = StyledNavigationController(rootViewController: assembly.makeModule())
        
        super.init(navigationController: navController)
        self.rootViewController = navigationController
    }
    
    // TODO: rewrite
    override func start() {
        if let vc =  rootViewController.topViewController as? InstancesViewController {
            vc.coordinator = self
        }
    }
    
    func goToAddInstance() {
        let assembly = AddInstanceAssembly()
        let module = assembly.makeModule()
        if let vc = module.topViewController as? InstancesViewController {
            vc.coordinator = self
        }
        
        self.rootViewController.present(module, animated: true)
    }
}
