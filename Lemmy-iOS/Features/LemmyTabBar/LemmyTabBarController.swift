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
    
    private(set) var communitiesVc: CommunitiesViewController!
    private(set) var createPostOrCommunityVc: CreatePostOrCommunityViewController!
    private(set) var frontPageVc: FrontPageViewController!
    
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
        frontPageVc = frontPageCoordinator.rootViewController
        
        let communitiesCoordinator = CommunitiesCoordinator(navigationController: nil)
        self.coordinator?.store(coordinator: communitiesCoordinator)
        communitiesCoordinator.start()
        let communitiesNc = UINavigationController(rootViewController: communitiesCoordinator.rootViewController)
        communitiesCoordinator.rootViewController.tabBarItem = UITabBarItem(title: "",
                                                                            image: UIImage(systemName: "person.2.fill"),
                                                                            tag: 1)
        communitiesCoordinator.navigationController = communitiesNc
        communitiesVc = communitiesCoordinator.rootViewController
        
        // its wrapper, real controller created in this method
        // func tabBarController(
        // _ tabBarController: UITabBarController,
        // shouldSelect viewController: UIViewController
        // ) -> Bool
        let createPostOrCommentController = CreatePostOrCommunityViewController()
        createPostOrCommentController.tabBarItem = UITabBarItem(title: "",
                                                                image: UIImage(systemName: "plus.circle"),
                                                                tag: 2)
        createPostOrCommunityVc = createPostOrCommentController
        
        self.viewControllers = [ frontPageNc,
                                 createPostOrCommentController,
                                 communitiesNc ]
        
        self.selectedIndex = 0
        
    }
}

extension LemmyTabBarController: UITabBarControllerDelegate {
    func createLoginAlert(_ tabBarController: UITabBarController) {
        let alertController = UIAlertController(title: nil, message: "Create an account to continue", preferredStyle: .alert)
        
        let loginAction = UIAlertAction(title: "Login", style: .default) { _ in
            self.coordinator?.goToLoginScreen(authMethod: .login)
        }
        
        let signUpAction = UIAlertAction(title: "Register", style: .default) { _ in
            self.coordinator?.goToLoginScreen(authMethod: .register)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        [loginAction, signUpAction, cancelAction].forEach { (action) in
            alertController.addAction(action)
        }
        tabBarController.present(alertController, animated: true, completion: nil)
    }
    
    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {
        
        if viewController is CreatePostOrCommunityViewController {
            
            // auth check
            if LemmyShareData.isLogined {
                coordinator?.goToCreateOrPostScreen()
            } else {
                createLoginAlert(tabBarController)
            }
            
            return false
        }
        
        return true
    }
}
