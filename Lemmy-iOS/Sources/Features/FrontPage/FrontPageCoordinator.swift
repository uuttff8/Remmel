//
//  FrontPageCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/11/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import SafariServices

class FrontPageCoordinator: NSObject, Coordinator {
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
        let coordinator = PostScreenCoordinator(navigationController: navigationController,
                                             postId: postId,
                                             postInfo: post)
        self.store(coordinator: coordinator)
        coordinator.start()
    }
    
    func goToCommunityScreen(communityId: Int) {
        let assembly = CommunityScreenAssembly(communityId: communityId, communityInfo: nil)
        let module = assembly.makeModule()
        self.navigationController?.pushViewController(module, animated: true)
    }
    
    func goToProfileScreen(by userId: Int) {
        let assembly = ProfileInfoScreenAssembly(profileId: userId)
        navigationController?.pushViewController(assembly.makeModule(), animated: true)
    }
    
    func goToSearchResults(searchQuery: String, searchType: LemmySearchSortType) {
        let assembly = SearchResultsAssembly(searchQuery: searchQuery, type: searchType)
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
    
    func goToBrowser(with url: URL) {
        let safariVc = SFSafariViewController(url: url)
        safariVc.delegate = self
        rootViewController.present(safariVc, animated: true)
    }
}

extension FrontPageCoordinator: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        rootViewController.dismiss(animated: true)
    }
}
