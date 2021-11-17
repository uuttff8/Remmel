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
    
    init(
        router: RouterProtocol?,
        postId: Int,
        postInfo: LMModels.Views.PostView? = nil,
        scrollToComment: LMModels.Views.CommentView? = nil
    ) {
        super.init(router: router)
        let assembly = PostScreenAssembly(postId: postId, postInfo: postInfo, scrollToComment: scrollToComment)
        self.rootViewController = assembly.makeModule()
        self.router?.viewController = self.rootViewController
    }

    override func start() {
        rootViewController.coordinator = self
    }
}
