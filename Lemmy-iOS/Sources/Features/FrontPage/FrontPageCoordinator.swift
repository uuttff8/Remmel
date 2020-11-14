//
//  FrontPageCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/11/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class FrontPageCoordinator: Coordinator {
    var rootViewController: FrontPageViewController
    var childCoordinators: [Coordinator] = []

    var navigationController: UINavigationController?

    lazy var postsViewController: PostsFrontPageViewController = {
        let vc = PostsFrontPageViewController()
        return vc
    }()

    lazy var commentsViewController: CommentsFrontPageViewController = {
        let vc = CommentsFrontPageViewController()
        return vc
    }()
    
    lazy var searchViewController = FrontPageSearchViewController()

    init(navigationController: UINavigationController?) {
        let assembly = FrontPageAssembly()
        
        self.rootViewController = assembly.makeModule() as! FrontPageViewController
        self.navigationController = navigationController
    }

    func start() {
        rootViewController.coordinator = self
        postsViewController.coordinator = self
        commentsViewController.coordinator = self
        searchViewController.coordinator = self
        navigationController?.pushViewController(self.rootViewController, animated: true)
        
        rootViewController.configureSearchView(searchViewController.view)
    }

    func switchViewController() {
        self.commentsViewController.view.isHidden =
            rootViewController.currentViewController != self.commentsViewController

        self.postsViewController.view.isHidden =
            rootViewController.currentViewController != self.postsViewController
    }
    
    func goToLoginScreen(authMethod: LemmyAuthMethod) {
        let loginCoordinator = LoginCoordinator(navigationController: UINavigationController(),
                                                authMethod: authMethod)
        self.store(coordinator: loginCoordinator)
        loginCoordinator.start()

        guard let loginNavController = loginCoordinator.navigationController else {
            print("\(#file) loginCoordinator.navigationController is nil")
            return
        }

        rootViewController.present(loginNavController, animated: true, completion: nil)
    }
    
    func goToPostScreen(postId: Int) {
        self.goToPostScreenWrapper(post: nil, postId: postId)
    }
    
    func goToPostScreen(post: LemmyModel.PostView) {
        self.goToPostScreenWrapper(post: post, postId: post.id)
    }
    
    private func goToPostScreenWrapper(post: LemmyModel.PostView?, postId: Int) {
        let assembly = PostScreenAssembly(postId: postId
                                          , postInfo: post)
        self.navigationController?.pushViewController(assembly.makeModule(), animated: true)
    }
    
    func goToCommunityScreen(communityId: Int) {
        let commScreen = CommunityScreenViewController(fromId: communityId)
        commScreen.coordinator = self
        self.navigationController?.pushViewController(commScreen, animated: true)
    }
    
    func goToProfileScreen(by username: String) {
        let assembly = ProfileInfoScreenAssembly(profileUsername: username)
        navigationController?.pushViewController(assembly.makeModule(), animated: true)
    }
    
    func showSearchIfNeeded(with query: String) {
        self.searchViewController.showSearchIfNeeded()
        self.searchViewController.searchQuery = query
    }
    
    func hideSearchIfNeeded() {
        self.searchViewController.hideSearchIfNeeded()
        self.searchViewController.searchQuery = ""
    }
}
