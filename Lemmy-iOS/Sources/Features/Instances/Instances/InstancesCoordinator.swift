//
//  InstancesCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 19.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import SwiftUI

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
    }
    
    func goToAddInstance(completion: @escaping () -> Void) {
        let assembly = AddInstanceAssembly()
        let module = assembly.makeModule()
        module.coordinator = self
        module.completionHandler = completion
        
        let navController = UINavigationController(rootViewController: module)
        
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
    
    func goToOnboarding(
        onUserOwnInstance: @escaping () -> Void,
        onLemmyMlInstance: @escaping () -> Void
    ) {
        let onboarding = OnboardingHostingController(rootView: OnboardingView())
        onboarding.onLemmyMlInstance = onLemmyMlInstance
        onboarding.onUserOwnInstance = onUserOwnInstance
        
        self.router.present(onboarding, animated: true)
    }
}

extension InstancesCoordinator: Drawable {
    var viewController: UIViewController? {
        self.rootViewController
    }
}
