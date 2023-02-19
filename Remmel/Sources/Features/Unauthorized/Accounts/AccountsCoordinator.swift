//
//  AccountsCoordinator.swift
//  Lemmy-iOS
//
//  Created by Komolbek Ibragimov on 24/12/2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMFoundation
import RMServices

final class AccountsCoordinator: BaseCoordinator {
    
    var rootViewController: AccountsViewController
    let router: RouterProtocol
    
    private let userAccountService: UserAccountSerivceProtocol = UserAccountService()
    
    init(router: RouterProtocol, instance: Instance) {
        let assembly = AccountsAssembly(instance: instance)
        self.rootViewController = assembly.makeModule()
        self.router = router
        self.router.viewController = self.rootViewController
        super.init()
    }
    
    override func start() {
        rootViewController.coordinator = self
    }
    
    func goToAddAccountModule(authMethod: LemmyAuthMethod, with instance: Instance, completion: @escaping () -> Void) {
        let assembly = AddAccountsAssembly(authMethod: authMethod, currentInstance: instance)
        let module = assembly.makeModule()
        module.coordinator = self
        module.completionHandler = completion
        let navController = UINavigationController(rootViewController: module)
        
        router.present(navController, animated: true)
    }
    
    func dismissSelf(viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func goToFrontPage() {
        
        if userAccountService.isAuthorized {
            debugPrint("Enter to instance with account")
            
            transitionToFrontPage()
        } else {
            debugPrint("Enter to instance as guest")
            
            transitionToFrontPage()
        }
    }
    
    private func transitionToFrontPage() {
        self.childCoordinators.removeAll()
        
        NotificationCenter.default.post(name: .didLogin, object: nil)

        let myCoordinator = LemmyTabBarCoordinator()
        self.childCoordinators.append(myCoordinator)
        myCoordinator.start()
        
        UIApplication.shared.windows.first?.replaceRootViewControllerWith(
            myCoordinator.rootViewController,
            animated: true
        )

    }
}

extension AccountsCoordinator: Drawable {
    var viewController: UIViewController? {
        self.rootViewController
    }
}
