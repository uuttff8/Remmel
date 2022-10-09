//
//  CreateDismissAnimator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/18/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class CreateMediaDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    private var transitionDriver: CreateMediaDismissTransitionDriver?

    // MARK: - Methods
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        CreateMediaTransitionDelegateImpl.duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionDriver = CreateMediaDismissTransitionDriver(transitionContext: transitionContext)
    }
}
