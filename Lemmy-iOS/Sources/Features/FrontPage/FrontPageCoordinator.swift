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
        let loginvc = LoginViewController(authMethod: authMethod)
        let navController = StyledNavigationController(rootViewController: loginvc)
        
        self.rootViewController.present(navController, animated: true)
    }
    
    func goToSearchResults(searchQuery: String, searchType: LMModels.Others.SearchType) {
        let assembly = SearchResultsAssembly(searchQuery: searchQuery, type: searchType)
        let vc = assembly.makeModule()
        vc.coordinator = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToSettings() {
        let assembly = SettingsAssembly()
        let module = assembly.makeModule()
        module.coordinator = self
        let navController = StyledNavigationController(rootViewController: module)
        
        router?.present(navController, animated: true)
    }
    
    func showSearchIfNeeded(with query: String) {
        searchViewController.coordinator = self
        searchViewController.showSearchIfNeeded()
        searchViewController.searchQuery = query
    }
    
    func hideSearchIfNeeded() {
        searchViewController.coordinator = nil
        searchViewController.hideSearchIfNeeded()
        searchViewController.searchQuery = ""
    }    
}
