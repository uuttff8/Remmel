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

    init(navigationController: UINavigationController?) {
        self.rootViewController = FrontPageViewController()
        self.navigationController = navigationController
    }

    func start() {
        rootViewController.coordinator = self
        postsViewController.coordinator = self
        commentsViewController.coordinator = self
        navigationController?.pushViewController(self.rootViewController, animated: true)
    }

    func switchViewController() {
        self.commentsViewController.view.isHidden =
            rootViewController.currentViewController != self.commentsViewController

        self.postsViewController.view.isHidden =
            rootViewController.currentViewController != self.postsViewController
    }

    func goToPostScreen(post: LemmyApiStructs.PostView) {
        let postScreen = PostScreenViewController(post: post)
        self.navigationController?.pushViewController(postScreen, animated: true)
    }
}
