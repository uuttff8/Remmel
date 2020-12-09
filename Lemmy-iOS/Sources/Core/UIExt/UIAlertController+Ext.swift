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
                                                 message: "Do you really want to exit",
                                                 preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
                onYes()
            })
            let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
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
        UIAlertAction(title: "Cancel", style: .cancel)
    }
}
