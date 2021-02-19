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
    func showMoreInPost<T: UIViewController>(on viewController: UIViewController,
                        coordinator: GenericCoordinator<T>,
                        post: LMModels.Views.PostView)
    
    func showMoreInComment<T: UIViewController>(on viewController: UIViewController,
                           coordinator: GenericCoordinator<T>,
                           comment: LMModels.Views.CommentView)
    
    func showMoreInReply(on viewController: InboxRepliesViewController,
                         coordinator: BaseCoordinator,
                         reply: LMModels.Views.CommentView)
    
    func showMoreInUserMention(on viewController: InboxMentionsViewController,
                               coordinator: BaseCoordinator,
                               mention: LMModels.Views.UserMentionView)
}

class ShowMoreHandlerService: ShowMoreHandlerServiceProtocol {
    
    private let networkService: RequestsManager
    private let userAccountService: UserAccountService
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        networkService: RequestsManager = ApiManager.requests,
        userAccountService: UserAccountService = UserAccountService()
    ) {
        self.networkService = networkService
        self.userAccountService = userAccountService
    }
    
    func showMoreInPost<T: UIViewController>(
        on viewController: UIViewController,
        coordinator: GenericCoordinator<T>,
        post: LMModels.Views.PostView
    ) {
        let mineActions = self.modPostAction(post: post.post, coordinator: coordinator)
        
        let alertController = createActionSheetController(vc: viewController)
        let savePostAction = self.createSavePostAction(postId: post.id, saved: post.saved)
        let shareAction = self.createShareAction(on: viewController, urlString: post.post.apId)
        
        let reportAction = UIAlertAction(title: "alert-report".localized, style: .destructive) { (_) in
            
            ContinueIfLogined(on: viewController, coordinator: coordinator) {
                self.reportPost(over: viewController, post: post.post)
            }
        }
        
        alertController.addActions(mineActions)
        
        alertController.addActions([
            savePostAction,
            shareAction,
            reportAction,
            UIAlertAction.cancelAction
        ])
        
        viewController.present(alertController, animated: true)
    }
    
    func showMoreInComment<T: UIViewController>(
        on viewController: UIViewController,
        coordinator: GenericCoordinator<T>,
        comment: LMModels.Views.CommentView
    ) {
        let alertController = createActionSheetController(vc: viewController)
        
        let shareAction = self.createShareAction(on: viewController, urlString: comment.getApIdRelatedToPost())
        let reportAction = UIAlertAction(title: "alert-report".localized, style: .destructive) { (_) in
            
            ContinueIfLogined(on: viewController, coordinator: coordinator) {
                self.reportComment(over: viewController, contentId: comment.comment.id)
            }
        }
        
        alertController.addActions([
            shareAction,
            reportAction,
            UIAlertAction.cancelAction
        ])
        
        viewController.present(alertController, animated: true)
    }
    
    func showMoreInReply(
        on viewController: InboxRepliesViewController,
        coordinator: BaseCoordinator,
        reply: LMModels.Views.CommentView
    ) {
        let alertController = createActionSheetController(vc: viewController)
        
        let sendMessageAction = UIAlertAction(title: "alert-send-message".localized, style: .default) { _ in
            let recipientId = reply.creator.id
            viewController.coordinator?.goToWriteMessage(recipientId: recipientId)
        }
        
        let reportAction = UIAlertAction(title: "alert-report".localized, style: .destructive) { (_) in
            
            ContinueIfLogined(on: viewController, coordinator: coordinator) {
                self.reportComment(over: viewController, contentId: reply.comment.id)
            }
        }
        
        alertController.addActions([
            sendMessageAction,
            reportAction,
            UIAlertAction.cancelAction
        ])
        viewController.present(alertController, animated: true)
    }
    
    func showMoreInUserMention(
        on viewController: InboxMentionsViewController,
        coordinator: BaseCoordinator,
        mention: LMModels.Views.UserMentionView
    ) {
        let alertController = createActionSheetController(vc: viewController)
        
        let sendMessageAction = UIAlertAction(title: "alert-send-message".localized, style: .default) { _ in
            let recipientId = mention.creator.id
            viewController.coordinator?.goToWriteMessage(recipientId: recipientId)
        }
        
        alertController.addAction(sendMessageAction)
        alertController.addAction(UIAlertAction.cancelAction)
        viewController.present(alertController, animated: true)
    }
    
    private func createActionSheetController(vc: UIViewController) -> UIAlertController {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.popoverPresentationController?.permittedArrowDirections = []
        alertController.popoverPresentationController?.sourceRect = CGRect(
            x: (vc.view.bounds.midX),
            y: (vc.view.bounds.midY),
            width: 0,
            height: 0
        )
        alertController.popoverPresentationController?.sourceView = vc.view
        return alertController
    }
    
    private func createShareAction(on viewController: UIViewController, urlString: String) -> UIAlertAction {
        return UIAlertAction(title: "alert-share".localized, style: .default, handler: { (_) in
            
            if let url = URL(string: urlString) {
                
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
    
    private func showAlertWithTextField(
        over viewController: UIViewController,
        reportAction: @escaping (String) -> Void
    ) {
        let controller = UIAlertController(title: nil, message: "alert-reason".localized, preferredStyle: .alert)
        controller.addTextField(configurationHandler: { tf in
            tf.placeholder = "alert-reason".localized
        })
        
        controller.addActions([
            UIAlertAction(title: "alert-cancel".localized, style: .cancel),
            UIAlertAction(title: "alert-report".localized, style: .default, handler: { _ in
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
        let action = UIAlertController(title: nil, message: "alert-thanks".localized, preferredStyle: .alert)
        action.addAction(UIAlertAction(title: "OK", style: .cancel))
        viewController.present(action, animated: true)
    }
    
    private func createSavePostAction(postId: Int, saved: Bool) -> UIAlertAction {
        if !saved {
            return UIAlertAction(title: "Save", style: .default) { (_) in
                self.savePost(postId: postId, toSave: true)
            }
        } else {
            return UIAlertAction(title: "Unsave", style: .default) { (_) in
                self.savePost(postId: postId, toSave: false)
            }
        }
    }
    
    fileprivate func modPostAction<T: UIViewController>(
        post: LMModels.Source.Post,
        coordinator: GenericCoordinator<T>
    ) -> [UIAlertAction] {
        if isMineUser(creatorId: post.creatorId) {
            
            let editAction = UIAlertAction(title: "Edit", style: .default) { (_) in
                coordinator.goToEditPost(post: post) {
                    LMMMessagesToast.showSuccessEditPost()
                }
            }
            
            let deleteAction: UIAlertAction
            if !post.deleted {
                deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
                    self.deletePost(postId: post.id, toDelete: true)
                }
            } else {
                deleteAction = UIAlertAction(title: "Restore", style: .destructive) { (_) in
                    self.deletePost(postId: post.id, toDelete: false)
                }
            }
            
            return [editAction, deleteAction]
            
        }
        
        return []
    }
    
    fileprivate func reportPost(over viewController: UIViewController, post: LMModels.Source.Post) {
        self.showAlertWithTextField(over: viewController) { reportReason in
            
            guard let jwtToken = LemmyShareData.shared.jwtToken else { return }
            let params = LMModels.Api.Post.CreatePostReport(postId: post.id,
                                                            reason: reportReason,
                                                            auth: jwtToken)
            
            self.networkService
                .asyncCreatePostReport(parameters: params)
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
    
    fileprivate func reportComment(over viewController: UIViewController, contentId: Int) {
        self.showAlertWithTextField(over: viewController) { reportReason in
            
            guard let jwtToken = LemmyShareData.shared.jwtToken else { return }
            let params = LMModels.Api.Comment.CreateCommentReport(
                commentId: contentId,
                reason: reportReason,
                auth: jwtToken
            )
            
            self.networkService.asyncCreateCommentReport(parameters: params)
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
    
    private func savePost(postId: Int, toSave: Bool) {
        guard let jwtToken = LemmyShareData.shared.jwtToken else { return }

        self.networkService.asyncSavePost(parameters: .init(postId: postId, save: toSave, auth: jwtToken))
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
                if case .failure = completion {
                    DispatchQueue.main.async {
                        LMMMessagesToast.showErrorSavePost()
                    }
                }
            } receiveValue: { (_) in
                DispatchQueue.main.async {
                    LMMMessagesToast.showSuccessSavePost()
                }
            }.store(in: &cancellables)
    }
    
    private func deletePost(postId: Int, toDelete: Bool) {
        guard let jwtToken = LemmyShareData.shared.jwtToken else { return }
        
        self.networkService.asyncDeletePost(parameters: .init(postId: postId, deleted: toDelete, auth: jwtToken))
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
                if case .failure = completion {
                    DispatchQueue.main.async {
                        LMMMessagesToast.showErrorDeletePost()
                    }
                }
            } receiveValue: { (_) in
                DispatchQueue.main.async {
                    LMMMessagesToast.showSuccessDeletePost()
                }
            }.store(in: &cancellables)

    }
    
    private func isMineUser(creatorId: Int) -> Bool {
        if userAccountService.currentUserID == creatorId {
            return true
        }
        
        return false
    }
}
