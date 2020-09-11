//
//  LemmyTabBarController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/11/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class LemmyTabBarController: UITabBarController {
    weak var coordinator: LemmyTabBarCoordinator?
    
    override func viewDidLoad() {
        let frontPageCoordinator = FrontPageCoordinator(navigationController: nil)
        self.coordinator?.store(coordinator: frontPageCoordinator)
        let frontPageNc = UINavigationController(rootViewController: frontPageCoordinator.rootViewController)
        frontPageCoordinator.rootViewController.tabBarItem = UITabBarItem(title: "",
                                                                          image: UIImage(systemName: "bolt.circle"),
                                                                          tag: 0)
        
        self.viewControllers = [frontPageNc]
        
        self.selectedIndex = 0
        
    }
}
