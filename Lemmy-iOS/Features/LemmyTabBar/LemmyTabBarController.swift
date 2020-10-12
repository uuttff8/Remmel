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
        self.delegate = self
    }
    
    func createTabs() {
        let frontPageCoordinator = FrontPageCoordinator(navigationController: nil)
        self.coordinator?.store(coordinator: frontPageCoordinator)
        frontPageCoordinator.start()
        let frontPageNc = UINavigationController(rootViewController: frontPageCoordinator.rootViewController)
        frontPageCoordinator.rootViewController.tabBarItem = UITabBarItem(title: "",
                                                                          image: UIImage(systemName: "bolt.circle"),
                                                                          tag: 0)
        frontPageCoordinator.navigationController = frontPageNc
        
        let communitiesCoordinator = CommunitiesCoordinator(navigationController: nil)
        self.coordinator?.store(coordinator: communitiesCoordinator)
        communitiesCoordinator.start()
        let communitiesNc = UINavigationController(rootViewController: communitiesCoordinator.rootViewController)
        communitiesCoordinator.rootViewController.tabBarItem = UITabBarItem(title: "",
                                                                            image: UIImage(systemName: "person.2.fill"),
                                                                            tag: 1)
        communitiesCoordinator.navigationController = communitiesNc
        
        // its wrapper, real controller created in this method
        // func tabBarController(
        // _ tabBarController: UITabBarController,
        // shouldSelect viewController: UIViewController
        // ) -> Bool
        let createPostOrCommentController = CreatePostOrCommunityViewController()
        createPostOrCommentController.tabBarItem = UITabBarItem(title: "",
                                                                image: UIImage(systemName: "plus.circle"),
                                                                tag: 2)
        
        self.viewControllers = [ frontPageNc,
                                 createPostOrCommentController,
                                 communitiesNc ]
        
        self.selectedIndex = 0
        
    }
}

extension LemmyTabBarController: UITabBarControllerDelegate {
    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {
        
        if viewController is CreatePostOrCommunityViewController {
            
            // TODO: Make LoginViewAlert to login
            let showView_debug = false
            
            if showView_debug /*logined*/ {
                let createPostOrCommCoordinator = CreatePostOrCommunityCoordinator(navigationController: nil)
                self.coordinator?.store(coordinator: createPostOrCommCoordinator)
                createPostOrCommCoordinator.start()
                tabBarController.present(CreatePostOrCommunityViewController(), animated: true, completion: nil)
            } else {
                
            }
            
            return false
        }
        
        return true
    }
}
