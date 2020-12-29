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
        let snapshotImageView = UIImageView(image: self.snapshot())
        self.addSubview(snapshotImageView)

        let dismissCompletion = { () -> Void in // dismiss all modal view controllers
            self.rootViewController = replacementController
            self.bringSubviewToFront(snapshotImageView)
            if animated {
                
                UIView.animate(withDuration: 0.4, animations: { () -> Void in
                    snapshotImageView.alpha = 0
                }, completion: { (_) -> Void in
                    snapshotImageView.removeFromSuperview()
                    completion?()
                })
                
            } else {
                snapshotImageView.removeFromSuperview()
                completion?()
            }
        }
        
        if self.rootViewController!.presentedViewController != nil {
            self.rootViewController!.dismiss(animated: false, completion: dismissCompletion)
        } else {
            dismissCompletion()
        }
    }
}
