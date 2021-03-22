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
    
    static func createShareAction(
        title: String,
        on viewController: UIViewController,
        toEndpoint endpoint: String
    ) -> UIAlertAction {
        return UIAlertAction(title: title, style: .default, handler: { (_) in
            
            if let url = URL(string: endpoint) {
                
                let safariActiv = SafariActivity(url: url)
                
                let activityVc = UIActivityViewController(
                    activityItems: [url],
                    applicationActivities: [safariActiv]
                )
                
                if let popoverController = activityVc.popoverPresentationController {
                    popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2,
                                                          y: UIScreen.main.bounds.height / 2,
                                                          width: 0,
                                                          height: 0)
                    popoverController.sourceView = viewController.view
                    popoverController.permittedArrowDirections = []
                }
                
                viewController.present(activityVc, animated: true)
            }
        })
    }
}
