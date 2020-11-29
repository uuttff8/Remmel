//
//  PostScreenCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 29.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class PostScreenCoordinator: Coordinator {
    var rootViewController: PostScreenViewController
    var childCoordinators: [Coordinator] = []

    var navigationController: UINavigationController?

    init(navigationController: UINavigationController?, postId: Int, postInfo: LemmyModel.PostView? = nil) {
        let assembly = PostScreenAssembly(postId: postId, postInfo: postInfo)
        self.rootViewController = assembly.makeModule()
        self.navigationController = navigationController
    }

    func start() {
        rootViewController.coordinator = self
        navigationController?.pushViewController(rootViewController, animated: true)
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
}
