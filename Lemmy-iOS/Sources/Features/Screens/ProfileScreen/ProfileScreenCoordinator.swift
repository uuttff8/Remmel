//
//  ProfileScreenCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 09.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class ProfileScreenCoordinator: GenericCoordinator<ProfileScreenViewController> {
    
    init(navigationController: UINavigationController?, profileId: Int) {
        super.init(navigationController: navigationController)
        let assembly = ProfileInfoScreenAssembly(profileId: profileId)
        self.rootViewController = assembly.makeModule()
    }
    
    override func start() {
        rootViewController.coordinator = self
        navigationController?.pushViewController(rootViewController, animated: true)
    }
    
}
