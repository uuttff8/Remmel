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
    private(set) var inboxNotificationsCoordinator: InboxNotificationsCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }
    
    func createTabs() {
        
        // FrontPage
        frontPageCoordinator = FrontPageCoordinator(router: nil)
        coordinator?.store(coordinator: frontPageCoordinator)
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
        frontPageCoordinator.router?.viewController = frontPageCoordinator.rootViewController
        frontPageCoordinator.navigationController = frontPageCoordinator.router?.navigationController
        
        // Communities
        communitiesCoordinator = CommunitiesCoordinator(router: nil)
        coordinator?.store(coordinator: communitiesCoordinator)
        communitiesCoordinator.start()
        let communitiesRouter = Router(
            navigationController: StyledNavigationController(
                rootViewController: communitiesCoordinator.rootViewController
            )
        )
        communitiesCoordinator.rootViewController.tabBarItem = UITabBarItem(title: "",
                                                                            image: UIImage(systemName: "person.2"),
                                                                            tag: 1)
        communitiesCoordinator.router = communitiesRouter
        communitiesCoordinator.router?.viewController = communitiesCoordinator.rootViewController
        communitiesCoordinator.navigationController = communitiesCoordinator.router?.navigationController
        
        // CreatePostOrComment (create media)
        createPostOrCommunityCoordinator = CreatePostOrCommunityCoordinator(navigationController: nil)
        let createPostOrCommentController = CreatePostOrCommunityViewController()
        createPostOrCommentController.tabBarItem = UITabBarItem(title: "",
                                                                image: UIImage(systemName: "plus.circle"),
                                                                tag: 2)
        
        // Inbox
        inboxNotificationsCoordinator = InboxNotificationsCoordinator(router: nil)
        coordinator?.store(coordinator: inboxNotificationsCoordinator)
        inboxNotificationsCoordinator.start()
        let inboxRouter = Router(
            navigationController: StyledNavigationController(
                rootViewController: inboxNotificationsCoordinator.rootViewController
            )
        )
        inboxNotificationsCoordinator.rootViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(systemName: "tray.and.arrow.down"),
            tag: 0
        )
        inboxNotificationsCoordinator.router = inboxRouter
        inboxNotificationsCoordinator.router?.viewController = inboxNotificationsCoordinator.rootViewController
        inboxNotificationsCoordinator.navigationController = inboxNotificationsCoordinator.router?.navigationController

        // swiftlint:disable force_unwrapping
        self.viewControllers = [
            frontPageRouter.navigationController!,
            createPostOrCommentController,
            communitiesRouter.navigationController!,
            inboxRouter.navigationController!
        ]
        
        self.selectedIndex = 0
    }
}

extension LemmyTabBarController: UITabBarControllerDelegate {
    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {
        
        if viewController is CreatePostOrCommunityViewController {
            guard let coord = coordinator else {
                return false
            }
            
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
