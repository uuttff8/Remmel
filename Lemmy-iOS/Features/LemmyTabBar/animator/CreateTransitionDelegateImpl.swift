//
//  CreateTransitionDelegateImpl.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/18/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CreateTransitionDelegateImpl: NSObject, UIViewControllerTransitioningDelegate {
    var animator: CreatePostOrCommAnimator?
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        guard let tabbarController = presenting as? LemmyTabBarController,
              let createController = presented as? CreatePostOrCommunityViewController
        else { return nil }
        
        animator = CreatePostOrCommAnimator(type: .present,
                                            tabbarController: tabbarController,
                                            createController: createController)
        return animator

    }
    
    func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {

        guard let createController = dismissed as? CreatePostOrCommunityViewController
            else { return nil }

        animator = CreatePostOrCommAnimator(type: .dismiss,
                                            tabbarController: nil,
                                            createController: createController)
        return animator
    }
}
