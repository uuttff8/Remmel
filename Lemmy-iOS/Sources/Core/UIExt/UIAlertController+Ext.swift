//
//  UIAlertController+Ext.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 03.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

extension UIAlertController {
    struct Configurations {
        
        static func reallyWantToExit(onYes: @escaping () -> Void) -> UIAlertController {
            let alertControl = UIAlertController(title: nil,
                                                 message: "really-exit-alert".localized,
                                                 preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "alert-yes".localized, style: .destructive, handler: { _ in
                onYes()
            })
            let noAction = UIAlertAction(title: "alert-no".localized, style: .default, handler: nil)
            alertControl.addAction(yesAction)
            alertControl.addAction(noAction)
            alertControl.preferredAction = noAction
            
            return alertControl
        }
    }
    
    open func addActions(_ actions: [UIAlertAction]) {
        actions.forEach { self.addAction($0) }
    }
}

extension UIAlertAction {
    static var cancelAction: UIAlertAction {
        UIAlertAction(title: "alert-cancel".localized, style: .cancel)
    }
}
