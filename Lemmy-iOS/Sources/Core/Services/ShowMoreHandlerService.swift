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
    func showMoreInComment(on viewController: UIViewController, comment: LemmyModel.CommentView)
}

class ShowMoreHandlerService: ShowMoreHandlerServiceProtocol {
    func showMoreInPost(on viewController: UIViewController, post: LemmyModel.PostView) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let shareAction = self.createShareAction(on: viewController, urlString: post.apId)
        
        let reportAction = UIAlertAction(title: "Report", style: .destructive) { (_) in
            print("reported")
        }
        
        alertController.addActions([
                                    shareAction,
                                    reportAction,
                                    UIAlertAction(title: "Cancel", style: .cancel)
        ])
        
        viewController.present(alertController, animated: true)
    }
    
    func showMoreInComment(on viewController: UIViewController, comment: LemmyModel.CommentView) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let shareAction = self.createShareAction(on: viewController, urlString: comment.getApIdRelatedToPost())
        let reportAction = UIAlertAction(title: "Report", style: .destructive) { (_) in
            print("reported")
        }
        
        alertController.addActions([
                                    shareAction,
                                    reportAction,
                                    UIAlertAction(title: "Cancel", style: .cancel)
        ])
        
        viewController.present(alertController, animated: true)
    }
    
    private func createShareAction(on viewController: UIViewController, urlString: String) -> UIAlertAction {
        return UIAlertAction(title: "Share", style: .default, handler: { (_) in
            
            if let url = URL(string: urlString) {
                
                let safariActiv = SafariActivity(url: url)
                
                let activityVc = UIActivityViewController(
                    activityItems: [url],
                    applicationActivities: [safariActiv]
                )
                
                viewController.present(activityVc, animated: true)
            }
        })
    }
}
