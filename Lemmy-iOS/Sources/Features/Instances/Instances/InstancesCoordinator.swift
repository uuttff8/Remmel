//
//  InstancesCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 19.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class InstancesCoordinator: GenericCoordinator<InstancesViewController> {
    
    init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
        let assembly = InstancesAssembly()
        self.rootViewController = assembly.makeModule()
    }
    
    override func start() {
        rootViewController.coordinator = self
        navigationController?.pushViewController(rootViewController, animated: false)
    }
    
    func goToAddInstance(completion: @escaping () -> Void) {
        let assembly = AddInstanceAssembly()
        let module = assembly.makeModule()
        module.coordinator = self
        module.completionHandler = completion
        
        let navController = StyledNavigationController(rootViewController: module)
        
        self.rootViewController.present(navController, animated: true)
    }
    
    func goToAccounts(from instance: Instance) {
        let coordinator = AccountsCoordinator(navigationController: self.navigationController, instance: instance)
        self.store(coordinator: coordinator) 
        coordinator.start()
    }
}
