//
//  CreatePostOrCommAnimator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/18/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class CreateMediaPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var transitionDriver: CreateMediaPresentTransitionDriver?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        CreateMediaTransitionDelegateImpl.duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionDriver = CreateMediaPresentTransitionDriver(transitionContext: transitionContext)
    }
}
