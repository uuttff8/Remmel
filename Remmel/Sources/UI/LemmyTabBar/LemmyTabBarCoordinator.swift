//
//  LemmyTabBarCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/11/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class LemmyTabBarCoordinator: GenericCoordinator<LemmyTabBarController> {

    init() {
        super.init(router: Router(navigationController: nil))
        self.rootViewController = LemmyTabBarController()
    }

    override func start() {
        rootViewController.coordinator = self
        rootViewController.createTabs()
    }

    func goToCreateOrPostScreen() {
        let createPostOrCommCoordinator = CreateMediaCoordinator(navigationController: nil)
        self.store(coordinator: createPostOrCommCoordinator)
        createPostOrCommCoordinator.start()

        createPostOrCommCoordinator.rootViewController.modalPresentationStyle = .custom
        let transition = CreateMediaTransitionDelegateImpl()
        createPostOrCommCoordinator.rootViewController.transitioningDelegate = transition

        rootViewController.present(createPostOrCommCoordinator.rootViewController, animated: true)
    }

    func goToLoginScreen(authMethod: LemmyAuthMethod) {
        let loginvc = LoginViewController(authMethod: authMethod)
        let navController = StyledNavigationController(rootViewController: loginvc)
        
        rootViewController.present(navController, animated: true)
    }

    func goToCreateCommunity() {
        let createCommCoord = CreateCommunityCoordinator(navigationController: StyledNavigationController())
        self.store(coordinator: createCommCoord)
        createCommCoord.start()

        guard let navController = createCommCoord.navigationController else {
            return
        }

        rootViewController.present(navController, animated: true)
    }

    func goToPost(post: LMModels.Views.PostView) {
        rootViewController.frontPageCoordinator.goToPostScreen(post: post)
    }
    
    func goToCommunity(community: LMModels.Views.CommunityView) {
        rootViewController.frontPageCoordinator.goToCommunityScreen(communityId: community.id)
    }
}
