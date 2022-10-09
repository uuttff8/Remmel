//
//  CreateTransitionDelegateImpl.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/18/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CreateMediaTransitionDelegateImpl: NSObject, UIViewControllerTransitioningDelegate {

    static let duration: TimeInterval = 0.3

    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {

        CreateMediaPresentAnimator()
    }

    func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {

        CreateMediaDismissAnimator()
    }
}
