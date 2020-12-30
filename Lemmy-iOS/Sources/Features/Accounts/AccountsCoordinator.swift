//
//  AccountsCoordinator.swift
//  Lemmy-iOS
//
//  Created by Komolbek Ibragimov on 24/12/2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class AccountsCoordinator: BaseCoordinator {
    
    var rootViewController: AccountsViewController
    let router: RouterProtocol
    
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
        
        if LemmyShareData.shared.isLoggedIn {
            self.free(coordinator: self)
            
            NotificationCenter.default.post(name: .didLogin, object: nil)
            
            let myCoordinator = LemmyTabBarCoordinator()
            myCoordinator.start()
            
            UIApplication.shared.windows.first!.replaceRootViewControllerWith(
                myCoordinator.rootViewController,
                animated: true
            )
        } else {
            fatalError("Unexpexted error, must not be happen")
        }
    }
}

extension AccountsCoordinator: Drawable {
    var viewController: UIViewController? {
        self.rootViewController
    }
}
