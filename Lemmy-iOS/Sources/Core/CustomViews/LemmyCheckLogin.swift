//
//  LemmyCheckLogin.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class ContinueIfLogined {

    var viewController: UIViewController
    var coordinator: Coordinator
    
    init(
        on viewController: UIViewController,
        coordinator: Coordinator,
        doAction: () -> Void
    ) {
        
        self.coordinator = coordinator
        self.viewController = viewController
        
        if LemmyShareData.shared.jwtToken != nil {
            doAction()
        } else {
            
            UIAlertController.showLoginOrRegisterAlert(
                on: viewController,
                onLogin: {
                    self.auth(authMethod: .login)
                }, onRegister: {
                    self.auth(authMethod: .register)
                })
            
        }
    }
    
    private func auth(authMethod: LemmyAuthMethod) {
        
        let loginCoordinator = LoginCoordinator(navigationController: UINavigationController(),
                                                authMethod: authMethod)
        coordinator.store(coordinator: loginCoordinator)
        loginCoordinator.start()

        guard let loginNavController = loginCoordinator.navigationController else {
            print("\(#file) loginCoordinator.navigationController is nil")
            return
        }

        viewController.present(loginNavController, animated: true, completion: nil)
    }
}
