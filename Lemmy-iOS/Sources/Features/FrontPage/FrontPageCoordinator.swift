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
    
    init(router: Router?) {
        super.init(router: router)
        let assembly = FrontPageAssembly()
        self.rootViewController = assembly.makeModule()
        self.router?.viewController = self.rootViewController
    }
    
    override func start() {
        rootViewController.coordinator = self
        postsViewController.coordinator = self
        commentsViewController.coordinator = self
        
        rootViewController.configureSearchView(searchViewController.view)
    }
    
    func switchViewController() {
        self.commentsViewController.view.isHidden =
            rootViewController.currentViewController != self.commentsViewController
        
        self.postsViewController.view.isHidden =
            rootViewController.currentViewController != self.postsViewController
    }
    
    func goToLoginScreen(authMethod: LemmyAuthMethod) {
        let loginCoordinator = LoginCoordinator(router: Router(navigationController: StyledNavigationController()),
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
//        searchViewController.loadView()
        searchViewController.showSearchIfNeeded()
        searchViewController.searchQuery = query
    }
    
    func hideSearchIfNeeded() {
        searchViewController.coordinator = nil
//        searchViewController.view.removeFromSuperview()
        searchViewController.hideSearchIfNeeded()
        searchViewController.searchQuery = ""
    }    
}
