//
//  CreateTransitionDelegateImpl.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/18/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CreateTransitionDelegateImpl: NSObject, UIViewControllerTransitioningDelegate {

    static let duration: TimeInterval = 0.5

    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {

        CreatePresentAnimator()
    }

    func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {

        CreateDismissAnimator()
    }
}
