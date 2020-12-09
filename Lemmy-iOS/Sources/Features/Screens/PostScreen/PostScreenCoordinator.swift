//
//  PostScreenCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 29.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import SafariServices

class PostScreenCoordinator: GenericCoordinator<PostScreenViewController> {
    
    init(navigationController: UINavigationController?, postId: Int, postInfo: LemmyModel.PostView? = nil) {
        super.init(navigationController: navigationController)
        let assembly = PostScreenAssembly(postId: postId, postInfo: postInfo)
        self.rootViewController = assembly.makeModule()
    }

    override func start() {
        rootViewController.coordinator = self
        navigationController?.pushViewController(rootViewController, animated: true)
    }
}
