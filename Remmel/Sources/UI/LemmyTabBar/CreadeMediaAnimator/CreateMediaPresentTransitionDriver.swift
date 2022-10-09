//
//  CreatePresentTransitionDriver.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/18/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

// swiftlint:disable force_unwrapping
// swiftlint:disable force_cast
class CreateMediaPresentTransitionDriver {
    
    // MARK: - Appearance

    struct Appearance {
        let backViewAlpha: CGFloat = 0.6
        let dropdownViewHeight = 150
    }
    
    // MARK: - Properties
    var animator: UIViewPropertyAnimator?
    private let ctx: UIViewControllerContextTransitioning
    private let container: UIView
    private let fromVC: UIViewController
    private let toVC: UIViewController
    private let fromView: UIView
    private let toView: UIView
    private let createViewController: CreateMediaViewController
    private let appearance: Appearance

    init(transitionContext: UIViewControllerContextTransitioning, appearance: Appearance = Appearance()) {
        self.ctx = transitionContext
        self.container = transitionContext.containerView
        self.fromVC = transitionContext.viewController(forKey: .from)!
        self.toVC = transitionContext.viewController(forKey: .to)!
        self.fromView = fromVC.view!
        self.toView = toVC.view!
        self.createViewController = toVC as! CreateMediaViewController
        self.appearance = appearance

        createAnimator()
    }

    // MARK: - Methods
    
    private func createAnimator() {

        container.addSubview(toView)

        // layout create view controller, without this it will not be layouted
        createViewController.view.layoutIfNeeded()

        animator = UIViewPropertyAnimator(
            duration: CreateMediaTransitionDelegateImpl.duration,
            curve: .easeInOut,
            animations: { [self] in
                fromVC.view.alpha = self.appearance.backViewAlpha
                
                createViewController.createView.snp.makeConstraints { make in
                    make.height.equalTo(self.appearance.dropdownViewHeight)
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
