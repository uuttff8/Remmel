//
//  CreateDismissTransitionDriver.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/18/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CreateDismissTransitionDriver {
    
    // MARK: - Properties
    var animator: UIViewPropertyAnimator?
    private let ctx: UIViewControllerContextTransitioning
    private let container: UIView
    private let fromVC: UIViewController
    private let toVC: UIViewController
    private let fromView: UIView
    private let toView: UIView
    private let createViewController: CreatePostOrCommunityViewController

    init(transitionContext: UIViewControllerContextTransitioning) {
        ctx = transitionContext
        container = transitionContext.containerView
        fromVC = transitionContext.viewController(forKey: .from)!
        toVC = transitionContext.viewController(forKey: .to)!
        fromView = fromVC.view!
        toView = toVC.view!
        createViewController = fromVC as! CreatePostOrCommunityViewController

        createAnimator()
    }
    
    // MARK: - Methods
    private func createAnimator() {
        
        animator = UIViewPropertyAnimator(
            duration: CreateTransitionDelegateImpl.duration,
            curve: .easeOut,
            animations: {
                self.toVC.view.alpha = 1.0
                self.createViewController.createView.snp.updateConstraints { (make) in
                    make.height.equalTo(0)
                }
                self.createViewController.view.layoutIfNeeded()
            })
        
        animator?.startAnimation()
        
        animator?.addCompletion { [weak self] _ in
            self?.completeAnimation()
        }
    }
    
    private func completeAnimation() {
        let success = !ctx.transitionWasCancelled
        ctx.completeTransition(success)
    }
}
