//
//  InstancesCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 19.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class InstancesCoordinator: BaseCoordinator {
    
    let rootViewController: InstancesViewController
    let router: RouterProtocol
    
    init(router: RouterProtocol) {
        let assembly = InstancesAssembly()
        self.rootViewController = assembly.makeModule()
        self.router = router
        self.router.viewController = self.rootViewController
        super.init()
    }
    
    override func start() {
        rootViewController.coordinator = self
//        router.setRoot(self.rootViewController, isAnimated: false)
    }
    
    func goToAddInstance(completion: @escaping () -> Void) {
        let assembly = AddInstanceAssembly()
        let module = assembly.makeModule()
        module.coordinator = self
        module.completionHandler = completion
        
        let navController = StyledNavigationController(rootViewController: module)
        
        self.router.present(navController, animated: true)
    }
    
    func goToAccounts(from instance: Instance) {
        let accCoordinator = AccountsCoordinator(router: Router(navigationController: router.navigationController),
                                              instance: instance)
        self.store(coordinator: accCoordinator)
        accCoordinator.start()
        
        accCoordinator.router.push(accCoordinator.rootViewController, isAnimated: true) {
            self.free(coordinator: accCoordinator)
        }
    }
}

extension InstancesCoordinator: Drawable {
    var viewController: UIViewController? {
        self.rootViewController
    }
}
