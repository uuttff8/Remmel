//
//  CreatePresentTransitionDriver.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/18/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

extension CreatePresentTransitionDriver {
    struct Appearance {
        let backViewAlpha: CGFloat = 0.5
        let dropdownViewHeight = 150
    }
}

// swiftlint:disable force_unwrapping
// swiftlint:disable force_cast
class CreatePresentTransitionDriver {

    // MARK: - Properties
    var animator: UIViewPropertyAnimator?
    private let ctx: UIViewControllerContextTransitioning
    private let container: UIView
    private let fromVC: UIViewController
    private let toVC: UIViewController
    private let fromView: UIView
    private let toView: UIView
    private let createViewController: CreatePostOrCommunityViewController
    private let appearance: Appearance

    init(transitionContext: UIViewControllerContextTransitioning, appearance: Appearance = Appearance()) {
        ctx = transitionContext
        container = transitionContext.containerView
        fromVC = transitionContext.viewController(forKey: .from)!
        toVC = transitionContext.viewController(forKey: .to)!
        fromView = fromVC.view!
        toView = toVC.view!
        createViewController = toVC as! CreatePostOrCommunityViewController
        self.appearance = appearance

        createAnimator()
        
    }

    // MARK: - Methods
    private func createAnimator() {

        container.addSubview(toView)

        // layout create view controller, without this it will not be layouted
        self.createViewController.view.layoutIfNeeded()

        animator = UIViewPropertyAnimator(duration: CreateTransitionDelegateImpl.duration, curve: .easeIn, animations: {
            self.fromVC.view.alpha = self.appearance.backViewAlpha

            self.createViewController.createView.snp.makeConstraints { make in
                make.height.equalTo(self.appearance.dropdownViewHeight)
            }
            self.createViewController.view.layoutIfNeeded()
        })

        animator?.startAnimation()

        animator?.addCompletion {
            [weak self] _ in
            
            self?.completeAnimation()
        }
    }

    private func completeAnimation() {
        let success = !ctx.transitionWasCancelled
        ctx.completeTransition(success)
    }
}
