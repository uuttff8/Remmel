//
//  CreatePostOrCommAnimator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/18/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class CreatePostOrCommAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    static let duration: TimeInterval = 1.25
    
    var propertyAnimator: UIViewPropertyAnimator?
    
    private let type: PresentationType
    private let tabbarController: LemmyTabBarController?
    private let createController: CreatePostOrCommunityViewController
    
    init?(type: PresentationType,
          tabbarController: LemmyTabBarController?,
          createController: CreatePostOrCommunityViewController) {
        
        self.type = type
        self.tabbarController = tabbarController
        self.createController = createController
        
//        guard let _ = tabbarController.view.window ?? createController.view.window
//        else { return nil }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        Self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let isPresenting = type.isPresenting
        
        let container = transitionContext.containerView
        
        guard let toView = createController.view
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
        guard let toVC = transitionContext.viewController(forKey: .to) else { return }
//
//        guard let fromView = tabbarController?.view
//        else {
//            transitionContext.completeTransition(true)
//            return
//
//        }
        
        container.addSubview(toView)
        
        toView.translatesAutoresizingMaskIntoConstraints = false
        let topC = toView.topAnchor.constraint(equalTo: container.topAnchor)
        topC.isActive = true
        toView.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        toView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        toView.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        container.layoutIfNeeded()
        
        propertyAnimator = UIViewPropertyAnimator(duration: Self.duration, curve: .easeOut, animations: {
//            topC.constant = UIScreen.main.bounds.size.height
            
            fromVC.view.alpha = isPresenting ? 0.5 : 1.0
            
            if isPresenting {
                fromVC.view.alpha = 0.5
            } else {
                toVC.view.alpha = 1.0
            }
        })

        propertyAnimator?.startAnimation()
        
        
        propertyAnimator?.addCompletion { _ in
            let success = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(success)
        }
        
//        transitionContext.completeTransition(true)
    }
    
}

extension CreatePostOrCommAnimator {
    enum PresentationType {
        
        case present
        case dismiss
        
        var isPresenting: Bool {
            return self == .present
        }
    }
}
