//
//  UIWindow+Ext.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 29.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

extension UIWindow {
    
    func replaceRootViewControllerWith(
        _ replacementController: UIViewController,
        animated: Bool,
        completion: (() -> Void)? = nil
    ) {
        let previousViewController = self.rootViewController
        
        let snapshotImageView = UIImageView(image: self.snapshot())
        self.addSubview(snapshotImageView)

        let dismissCompletion = { () -> Void in // dismiss all modal view controllers
            self.rootViewController = replacementController
            self.bringSubviewToFront(snapshotImageView)
            if animated {
                
                UIView.animate(
                    withDuration: 0.4,
                    animations: {
                        snapshotImageView.alpha = 0
                    }, completion: { _ in
                        snapshotImageView.removeFromSuperview()
                        completion?()
                    }
                )
                
            } else {
                snapshotImageView.removeFromSuperview()
                completion?()
            }
        }
        
        if let rootViewController = rootViewController, rootViewController.presentedViewController != nil {
            rootViewController.dismiss(animated: false, completion: dismissCompletion)
        } else {
            dismissCompletion()
        }
        
        if let previousViewController = previousViewController {
            // Allow the view controller to be deallocated
            previousViewController.dismiss(animated: false) {
                // Remove the root view in case its still showing
                previousViewController.view.removeFromSuperview()
            }
        }
    }
}
