//
//  CreateDismissTransitionDriver.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/18/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

//swiftlint:disable force_cast
//swiftlint:disable force_unwrapping
class CreateMediaDismissTransitionDriver {
    
    // MARK: - Properties
    var animator: UIViewPropertyAnimator?
    private let ctx: UIViewControllerContextTransitioning
    private let container: UIView
    private let fromVC: UIViewController
    private let toVC: UIViewController
    private let fromView: UIView
    private let toView: UIView
    private let createViewController: CreateMediaViewController

    init(transitionContext: UIViewControllerContextTransitioning) {
        self.ctx = transitionContext
        self.container = transitionContext.containerView
        self.fromVC = transitionContext.viewController(forKey: .from)!
        self.toVC = transitionContext.viewController(forKey: .to)!
        self.fromView = fromVC.view!
        self.toView = toVC.view!
        self.createViewController = fromVC as! CreateMediaViewController

        createAnimator()
    }
    
    // MARK: - Methods
    private func createAnimator() {
        
        animator = UIViewPropertyAnimator(
            duration: CreateMediaTransitionDelegateImpl.duration,
            curve: .easeInOut,
            animations: { [self] in
                toVC.view.alpha = 1.0
                createViewController.createView.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
                createViewController.view.layoutIfNeeded()
            }
        )
        
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
