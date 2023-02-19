//
//  GenericCoordinator+Instances.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 08/10/2022.
//  Copyright © 2022 Anton Kuzmin. All rights reserved.
//

import RMFoundation
import UIKit

extension GenericCoordinator {
    func goToInstances() {
        LemmyShareData.shared.loginData.logout()
        
        if !userAccountService.isAuthorized {
            self.childCoordinators.removeAll()
            
            NotificationCenter.default.post(name: .didLogin, object: nil)
            
            let myCoordinator = InstancesCoordinator(router: Router(navigationController: StyledNavigationController()))
            myCoordinator.start()
            childCoordinators.append(myCoordinator)
            myCoordinator.router.setRoot(myCoordinator, isAnimated: true)
            
            guard let appWindow = UIApplication.shared.windows.first, let navController = myCoordinator.router.navigationController else {
                debugPrint("App must have only one `root` window")
                return
            }
            
            appWindow.replaceRootViewControllerWith(navController, animated: true)
        } else {
            debugPrint("At going to instances, we must logout user!")
            fatalError("Unexpexted error, must not be happen")
        }
    }
}
