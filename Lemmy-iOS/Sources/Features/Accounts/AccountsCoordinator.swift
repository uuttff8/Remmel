//
//  AccountsCoordinator.swift
//  Lemmy-iOS
//
//  Created by Komolbek Ibragimov on 24/12/2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class AccountsCoordinator: Coordinator {
    
    var rootViewController: AccountsViewController
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    
    init(navController: UINavigationController) {
        let assembly = AccountsAssembly()
        self.rootViewController = assembly.makeModule()
        
        self.navigationController = navController
    }
    
    func start() {
        rootViewController.coordinator = self
        navigationController?.pushViewController(rootViewController, animated: true)
    }
    
    func goToAddAccountModule(authMethod: LemmyAuthMethod) {
        let assembly = AddAccountsAssembly(authMethod: authMethod)
        let module = assembly.makeModule()
        
        navigationController?.present(module, animated: true, completion: nil)
    }
    
    func dismissSelf(viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
