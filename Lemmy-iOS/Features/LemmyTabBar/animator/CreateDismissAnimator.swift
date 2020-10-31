//
//  CreateDismissAnimator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/18/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class CreateDismissPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    private var transitionDriver: CreateDismissTransitionDriver?

    // MARK: - Methods
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return CreateTransitionDelegateImpl.duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionDriver = CreateDismissTransitionDriver(transitionContext: transitionContext)
    }
}
