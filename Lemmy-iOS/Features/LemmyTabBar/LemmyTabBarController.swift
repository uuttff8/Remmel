//
//  LemmyTabBarController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/11/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol TabBarReselectHandling {
    func handleReselect()
}

class LemmyTabBarController: UITabBarController {
    weak var coordinator: LemmyTabBarCoordinator?
    
    private(set) var communitiesCoordinator: CommunitiesCoordinator!
    private(set) var createPostOrCommunityCoordinator: CreatePostOrCommunityCoordinator!
    private(set) var frontPageCoordinator: FrontPageCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }
    
    func createTabs() {
        
        frontPageCoordinator = FrontPageCoordinator(navigationController: nil)
        self.coordinator?.store(coordinator: frontPageCoordinator)
        frontPageCoordinator.start()
        let frontPageNc = UINavigationController(rootViewController: frontPageCoordinator.rootViewController)
        frontPageCoordinator.rootViewController.tabBarItem = UITabBarItem(title: "",
                                                                          image: UIImage(systemName: "bolt.circle"),
                                                                          tag: 0)
        frontPageCoordinator.navigationController = frontPageNc
        
        self.communitiesCoordinator = CommunitiesCoordinator(navigationController: nil)
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
        
        self.createPostOrCommunityCoordinator = CreatePostOrCommunityCoordinator(navigationController: nil)
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
    func createLoginAlert(_ tabBarController: UITabBarController) {
        let alertController = UIAlertController(
            title: nil,
            message: "Create an account to continue",
            preferredStyle: .alert
        )
        
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
        
        let controller = viewController as? UINavigationController
        let tabBarControllerVC = tabBarController.selectedViewController as? UINavigationController
        
        if tabBarControllerVC?.viewControllers.first === controller?.viewControllers.first,
           let handler = tabBarControllerVC?.viewControllers.first as? TabBarReselectHandling {
            // NOTE: viewController in line above might be a UINavigationController,
            // in which case you need to access its contents
            handler.handleReselect()
        }
        
        return true
    }
}
