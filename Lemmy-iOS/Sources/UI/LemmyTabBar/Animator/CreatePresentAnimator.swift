//
//  CreatePostOrCommAnimator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/18/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class CreatePresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var transitionDriver: CreatePresentTransitionDriver?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        CreateTransitionDelegateImpl.duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionDriver = CreatePresentTransitionDriver(transitionContext: transitionContext)
    }
}
