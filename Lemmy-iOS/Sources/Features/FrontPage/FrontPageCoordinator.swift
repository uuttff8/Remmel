//
//  FrontPageCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/11/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import SafariServices

class FrontPageCoordinator: GenericCoordinator<FrontPageViewController> {
    
    lazy var postsViewController: PostsFrontPageViewController = {
        let vc = PostsFrontPageViewController()
        return vc
    }()

    lazy var commentsViewController: CommentsFrontPageViewController = {
        let vc = CommentsFrontPageViewController()
        return vc
    }()
    
    lazy var searchViewController = FrontPageSearchViewController()

    override init(navigationController: UINavigationController?) {
        super.init(navigationController: navigationController)
        let assembly = FrontPageAssembly()
        self.rootViewController = assembly.makeModule()
    }

    override func start() {
        rootViewController.coordinator = self
        postsViewController.coordinator = self
        commentsViewController.coordinator = self
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
            Logger.commonLog.emergency("FrontPage coordinator is nil")
            return
        }

        rootViewController.present(loginNavController, animated: true, completion: nil)
    }
        
    func goToSearchResults(searchQuery: String, searchType: LemmySearchSortType) {
        let assembly = SearchResultsAssembly(searchQuery: searchQuery, type: searchType)
        let vc = assembly.makeModule()
        vc.coordinator = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showSearchIfNeeded(with query: String) {
        searchViewController.coordinator = self
        self.searchViewController.showSearchIfNeeded()
        self.searchViewController.searchQuery = query
    }
    
    func hideSearchIfNeeded() {
        searchViewController.coordinator = nil
        self.searchViewController.hideSearchIfNeeded()
        self.searchViewController.searchQuery = ""
    }
}
