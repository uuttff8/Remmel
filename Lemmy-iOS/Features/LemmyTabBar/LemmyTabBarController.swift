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
        frontPageCoordinator.start()
        let frontPageNc = UINavigationController(rootViewController: frontPageCoordinator.rootViewController)
        frontPageCoordinator.rootViewController.tabBarItem = UITabBarItem(title: "",
                                                                          image: UIImage(systemName: "bolt.circle"),
                                                                          tag: 0)
        
        let communitiesCoordinator = CommunitiesCoordinator(navigationController: nil)
        self.coordinator?.store(coordinator: communitiesCoordinator)
        communitiesCoordinator.start()
        let communitiesNc = UINavigationController(rootViewController: communitiesCoordinator.rootViewController)
        communitiesCoordinator.rootViewController.tabBarItem = UITabBarItem(title: "",
                                                                            image: UIImage(systemName: "person.2.fill"),
                                                                            tag: 1)
        
        self.viewControllers = [frontPageNc, communitiesNc]
        
        self.selectedIndex = 0
        
    }
}
