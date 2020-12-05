//
//  PostShowMoreHandlerService.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 05.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol ShowMoreHandlerServiceProtocol {
    func showMoreInPost(on viewController: UIViewController, post: LemmyModel.PostView)
}

class ShowMoreHandlerService: ShowMoreHandlerServiceProtocol {
    func showMoreInPost(on viewController: UIViewController, post: LemmyModel.PostView) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(title: "Share", style: .default, handler: { (_) in
            
            if let url = URL(string: post.apId) {
                
                let safariActiv = SafariActivity(url: url)
                
                let activityVc = UIActivityViewController(
                    activityItems: [url],
                    applicationActivities: [safariActiv]
                )
                
                viewController.present(activityVc, animated: true)
            }
        })
        
        let reportAction = UIAlertAction(title: "Report", style: .destructive) { (_) in
            print("reported")
        }
        
        alertController.addAction(shareAction)
        alertController.addAction(reportAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        viewController.present(alertController, animated: true)
    }
}
