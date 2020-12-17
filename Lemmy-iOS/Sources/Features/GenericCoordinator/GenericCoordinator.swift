//
//  GenericCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 09.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import SafariServices

class GenericCoordinator<T: UIViewController>: NSObject, Coordinator, SFSafariViewControllerDelegate {
    var rootViewController: T! // implement it 
    var childCoordinators: [Coordinator] = []

    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start() {
        fatalError("Override this")
    }
    
    func goToCommunityScreen(communityId: Int) {
        let coordinator = CommunityScreenCoordinator(navigationController: navigationController, communityId: communityId, communityInfo: nil)
        self.store(coordinator: coordinator)
        coordinator.start()
    }
    
    func goToProfileScreen(by userId: Int) {
        let coordinator = ProfileScreenCoordinator(navigationController: navigationController, profileId: userId)
        self.store(coordinator: coordinator)
        coordinator.start()
    }
    
    func goToBrowser(with url: URL) {
        let safariVc = SFSafariViewController(url: url)
        safariVc.delegate = self
        rootViewController.present(safariVc, animated: true)
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
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.rootViewController.dismiss(animated: true)
    }
}
