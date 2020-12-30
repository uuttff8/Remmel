//
//  LemmyCheckLogin.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

// TODO refactor this class and remove boilerplate
func ContinueIfLogined(
    on viewController: UIViewController,
    coordinator: BaseCoordinator,
    doAction: () -> Void,
    elseAction: (() -> Void)? = nil
) {
    
    func auth(authMethod: LemmyAuthMethod) {
        
        // I know, it's bad to access Feature/ classes from Core/
        let loginCoordinator = LoginCoordinator(router: Router(navigationController: StyledNavigationController()),
                                                authMethod: authMethod)
        coordinator.store(coordinator: loginCoordinator)
        loginCoordinator.start()
        
        guard let loginNavController = loginCoordinator.navigationController else {
            Logger.commonLog.error("LoginCoordinator.navigationController is nil")
            return
        }
        
        viewController.present(loginNavController, animated: true, completion: nil)
    }
    
    func goToInstances() {
        LemmyShareData.shared.loginData.logout()
        
        if !LemmyShareData.shared.isLoggedIn {
            coordinator.childCoordinators.removeAll()
            
            NotificationCenter.default.post(name: .didLogin, object: nil)
            
            let myCoordinator = InstancesCoordinator(router: Router(navigationController: StyledNavigationController()))
            myCoordinator.start()
            coordinator.childCoordinators.append(myCoordinator)
            myCoordinator.router.setRoot(myCoordinator, isAnimated: true)

            UIApplication.shared.windows.first!.replaceRootViewControllerWith(
                myCoordinator.router.navigationController!,
                animated: true
            )
        } else {
            fatalError("Unexpexted error, must not be happen")
        }
    }
    
    if LemmyShareData.shared.isLoggedIn {
        doAction()
    } else {
        elseAction?()
        UIAlertController.showLoginOrRegisterAlert(
            on: viewController,
            onLogin: {
                auth(authMethod: .auth)
            }, onRegister: {
                auth(authMethod: .register)
            }, onInstances: {
                goToInstances()
            })
    }
}
