//
//  LemmyTabBarCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/11/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class LemmyTabBarCoordinator: BaseCoordinator {
    var rootViewController: LemmyTabBarController

    override init() {
        self.rootViewController = LemmyTabBarController()
        super.init()
    }

    override func start() {
        rootViewController.coordinator = self
        rootViewController.createTabs()
    }

    func goToCreateOrPostScreen() {
        let createPostOrCommCoordinator = CreatePostOrCommunityCoordinator(navigationController: nil)
        self.store(coordinator: createPostOrCommCoordinator)
        createPostOrCommCoordinator.start()

        createPostOrCommCoordinator.rootViewController.modalPresentationStyle = .custom
        let transition = CreateTransitionDelegateImpl()
        createPostOrCommCoordinator.rootViewController.transitioningDelegate = transition

        rootViewController.present(createPostOrCommCoordinator.rootViewController, animated: true)
    }

    func goToLoginScreen(authMethod: LemmyAuthMethod) {
        let loginvc = LoginViewController(authMethod: authMethod)
        let navController = StyledNavigationController(rootViewController: loginvc)
        
        rootViewController.present(navController, animated: true)
    }

    func goToCreatePost() {
        let createPostCoord = CreatePostCoordinator(navigationController: StyledNavigationController())
        self.store(coordinator: createPostCoord)
        createPostCoord.start()

        guard let navController = createPostCoord.navigationController else { return }

        rootViewController.present(navController, animated: true)
    }

    func goToCreateCommunity() {
        let createCommCoord = CreateCommunityCoordinator(navigationController: StyledNavigationController())
        self.store(coordinator: createCommCoord)
        createCommCoord.start()

        guard let navController = createCommCoord.navigationController else { return }

        rootViewController.present(navController, animated: true)
    }

    func goToPost(post: LemmyModel.PostView) {
        rootViewController.frontPageCoordinator.goToPostScreen(post: post)
    }
    
    func goToCommunity(community: LemmyModel.CommunityView) {
        rootViewController.frontPageCoordinator.goToCommunityScreen(communityId: community.id)
    }
}
