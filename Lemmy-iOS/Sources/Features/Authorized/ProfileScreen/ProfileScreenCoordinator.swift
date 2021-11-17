//
//  ProfileScreenCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 09.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class ProfileScreenCoordinator: GenericCoordinator<ProfileScreenViewController> {
    
    init(router: Router?, profileId: Int?, profileUsername: String?) {
        assert(profileId != nil || profileUsername != nil, "One of these arguments should not be nil")
        
        super.init(router: router)
        let assembly = ProfileInfoScreenAssembly(profileId: profileId, profileUsername: profileUsername)
        self.rootViewController = assembly.makeModule()
        self.router?.viewController = self.rootViewController
    }
    
    override func start() {
        rootViewController.coordinator = self
    }
    
    func goToProfileSettings() {
        let assembly = ProfileSettingsAssembly()
        let module = assembly.makeModule()
        module.coordinator = self
        let navController = StyledNavigationController(rootViewController: module)
        
        router?.present(navController, animated: true)
    }
}
