//
//  ProfileScreenCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 09.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class ProfileScreenCoordinator: GenericCoordinator<ProfileScreenViewController> {
    
    init(navigationController: UINavigationController?, profileId: Int?, profileUsername: String?) {
        assert(profileId != nil || profileUsername != nil, "One of these arguments should not be nil")
        
        super.init(navigationController: navigationController)
        let assembly = ProfileInfoScreenAssembly(profileId: profileId, profileUsername: profileUsername)
        self.rootViewController = assembly.makeModule()
    }
    
    override func start() {
        rootViewController.coordinator = self
        navigationController?.pushViewController(rootViewController, animated: true)
    }
    
    func goToInstances() {
        LemmyShareData.shared.loginData.logout()
        
        // FIXME(uuttff8): We should know, if memory is not cleared
        if !LemmyShareData.shared.isLoggedIn {
            NotificationCenter.default.post(name: .didLogin, object: nil)
            
            let myCoordinator = InstancesCoordinator()

            // store child coordinator
            self.store(coordinator: myCoordinator)
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
