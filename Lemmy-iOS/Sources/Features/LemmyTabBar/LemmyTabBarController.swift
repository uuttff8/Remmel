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
        
        frontPageCoordinator = FrontPageCoordinator(router: nil)
        self.coordinator?.store(coordinator: frontPageCoordinator)
        frontPageCoordinator.start()
        let frontPageRouter = Router(
            navigationController: StyledNavigationController(
                rootViewController: frontPageCoordinator.rootViewController
            )
        )
        frontPageCoordinator.rootViewController.tabBarItem = UITabBarItem(title: "",
                                                                          image: UIImage(systemName: "bolt.circle"),
                                                                          tag: 0)
        frontPageCoordinator.router = frontPageRouter
        
        self.communitiesCoordinator = CommunitiesCoordinator(router: nil)
        self.coordinator?.store(coordinator: communitiesCoordinator)
        communitiesCoordinator.start()
        let communitiesRouter = Router(
            navigationController: StyledNavigationController(
                rootViewController: communitiesCoordinator.rootViewController
            )
        )
        communitiesCoordinator.rootViewController.tabBarItem = UITabBarItem(title: "",
                                                                            image: UIImage(systemName: "person.2.fill"),
                                                                            tag: 1)
        communitiesCoordinator.router = communitiesRouter
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
        
        self.viewControllers = [ frontPageRouter.navigationController!,
                                 createPostOrCommentController,
                                 communitiesRouter.navigationController! ]
        
        self.selectedIndex = 0
        
    }
}

extension LemmyTabBarController: UITabBarControllerDelegate {
    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {
        
        if viewController is CreatePostOrCommunityViewController {
            
            guard let coord = self.coordinator else { return false }
            
            ContinueIfLogined(on: self, coordinator: coord) {
                coordinator?.goToCreateOrPostScreen()
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
