//
//  LemmyTabBarCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/11/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class LemmyTabBarCoordinator: Coordinator {
    var rootViewController: LemmyTabBarController
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController? = {
       return nil
    }()
    
    init() {
        self.rootViewController = LemmyTabBarController()
    }
        
    func start() {
        rootViewController.coordinator = self
    }
}
