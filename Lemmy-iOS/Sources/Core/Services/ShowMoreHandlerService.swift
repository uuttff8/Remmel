//
//  PostShowMoreHandlerService.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 05.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

protocol ShowMoreHandlerServiceProtocol {
    func showMoreInPost(on viewController: UIViewController, post: LemmyModel.PostView)
    func showMoreInComment(on viewController: UIViewController, comment: LemmyModel.CommentView)
}

class ShowMoreHandlerService: ShowMoreHandlerServiceProtocol {
    
    private let networkService: ApiManager
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        networkService: ApiManager = .shared
    ) {
        self.networkService = networkService
    }
    
    func showMoreInPost(on viewController: UIViewController, post: LemmyModel.PostView) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let shareAction = self.createShareAction(on: viewController, urlString: post.apId)
        
        let reportAction = UIAlertAction(title: "Report", style: .destructive) { (_) in
            
            self.showAlertWithTextField(over: viewController) { reportReason in
                
                guard let jwtToken = LemmyShareData.shared.jwtToken else { return }
                let params = LemmyModel.Post.CreatePostReportRequest(postId: post.id,
                                                                     reason: reportReason,
                                                                     auth: jwtToken)
                
                self.networkService.requestsManager.asyncCreatePostReport(parameters: params)
                    .receive(on: DispatchQueue.main)
                    .sink { (completion) in
                        Logger.logCombineCompletion(completion)
                    } receiveValue: { (response) in
                        
                        if response.success {
                            self.showWasReportedAlert(over: viewController)
                        }
                        
                    }.store(in: &self.cancellables)
            }
        }
        
        alertController.addAction(shareAction)
        if LemmyShareData.shared.jwtToken != nil {
            alertController.addAction(reportAction)
        }
        alertController.addAction(UIAlertAction.cancelAction)
        
        viewController.present(alertController, animated: true)
    }
    
    func showMoreInComment(on viewController: UIViewController, comment: LemmyModel.CommentView) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let shareAction = self.createShareAction(on: viewController, urlString: comment.getApIdRelatedToPost())
        let reportAction = UIAlertAction(title: "Report", style: .destructive) { (_) in
            
            self.showAlertWithTextField(over: viewController) { reportReason in
                
                guard let jwtToken = LemmyShareData.shared.jwtToken else { return }
                let params = LemmyModel.Comment.CreateCommentReportRequest(
                    commentId: comment.id,
                    reason: reportReason,
                    auth: jwtToken
                )
                
                self.networkService.requestsManager.asyncCreateCommentReport(parameters: params)
                    .receive(on: DispatchQueue.main)
                    .sink { (completion) in
                        Logger.logCombineCompletion(completion)
                    } receiveValue: { (response) in
                        
                        if response.success {
                            self.showWasReportedAlert(over: viewController)
                        }
                        
                    }.store(in: &self.cancellables)
            }
        }

        alertController.addActions([
            shareAction,
            reportAction,
            UIAlertAction.cancelAction
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
    
    private func showAlertWithTextField(
        over viewController: UIViewController,
        reportAction: @escaping (String) -> Void
    ) {
        let controller = UIAlertController(title: nil, message: "Reason", preferredStyle: .alert)
        controller.addTextField(configurationHandler: { tf in
            tf.placeholder = "Text here"
        })
        
        controller.addActions([
            UIAlertAction(title: "Cancel", style: .cancel),
            UIAlertAction(title: "Report", style: .default, handler: { _ in
                if let textFieldText = controller.textFields!.first!.text, !textFieldText.isEmpty {
                    reportAction(textFieldText)
                } else {
                    self.showAlertWithTextField(over: viewController, reportAction: reportAction)
                }
            })
        ])
        
        viewController.present(controller, animated: true)
    }
    
    private func showWasReportedAlert(over viewController: UIViewController) {
        let action = UIAlertController(title: nil, message: "Thank you", preferredStyle: .alert)
        action.addAction(UIAlertAction(title: "OK", style: .cancel))
        viewController.present(action, animated: true)
    }
}
