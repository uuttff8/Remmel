//
//  LemmyCheckLogin.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

func ContinueIfLogined(
    on viewController: UIViewController,
    coordinator: Coordinator,
    doAction: () -> Void,
    elseAction: (() -> Void)? = nil
) {
    
    func auth(authMethod: LemmyAuthMethod) {
        
        // I know, it's bad to access Feature/ classes from Core/
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
    
    if LemmyShareData.shared.isLoggedIn {
        doAction()
    } else {
        elseAction?()
        UIAlertController.showLoginOrRegisterAlert(
            on: viewController,
            onLogin: {
                auth(authMethod: .login)
            }, onRegister: {
                auth(authMethod: .register)
            })
        
    }
}
