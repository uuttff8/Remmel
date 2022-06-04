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
    func showMoreInPost<T: UIViewController>(
        on viewController: UIViewController,
        coordinator: GenericCoordinator<T>,
        post: LMModels.Views.PostView,
        updateCompletion: @escaping ((LMModels.Views.PostView) -> Void)
    )
    
    func showMoreInComment<T: UIViewController>(
        on viewController: UIViewController,
        coordinator: GenericCoordinator<T>,
        comment: LMModels.Views.CommentView,
        updateCompletion: @escaping ((LMModels.Views.CommentView) -> Void)
    )
    
    func showMoreInReply(
        on viewController: InboxRepliesViewController,
        coordinator: BaseCoordinator,
        reply: LMModels.Views.CommentView,
        updateCompletion: @escaping ((LMModels.Views.CommentView) -> Void)
    )
    
    func showMoreInUserMention(
        on viewController: InboxMentionsViewController,
        coordinator: BaseCoordinator,
        mention: LMModels.Views.PersonMentionView
//        updateCompletion: @escaping ((LMModels.Views.CommentView) -> Void)
    )
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
        post: LMModels.Views.PostView,
        updateCompletion: @escaping ((LMModels.Views.PostView) -> Void)
    ) {
        let mineActions = self.minePostActions(post: post.post, coordinator: coordinator, completion: updateCompletion)
        
        let alertController = createActionSheetController(vc: viewController)
        let savePostAction = self.createSavePostAction(postId: post.id, saved: post.saved, completion: updateCompletion)
        let shareAction = self.createShareAction(on: viewController, toEndpoint: post.post.apId)
        
        let reportAction = UIAlertAction(title: "alert-report".localized, style: .destructive) { _ in
            
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
        comment: LMModels.Views.CommentView,
        updateCompletion: @escaping ((LMModels.Views.CommentView) -> Void)
    ) {
        let alertController = createActionSheetController(vc: viewController)
        
        let mineActions = self.mineCommentActions(comment: comment.comment, coordinator: coordinator)
        let saveCommentAction = self.createSaveCommentAction(commentId: comment.id,
                                                             saved: comment.saved,
                                                             completion: updateCompletion)
        let shareAction = self.createShareAction(on: viewController, toEndpoint: comment.getApIdRelatedToPost())
        let reportAction = UIAlertAction(title: "alert-report".localized, style: .destructive) { _ in
            
            ContinueIfLogined(on: viewController, coordinator: coordinator) {
                self.reportComment(over: viewController, contentId: comment.comment.id)
            }
        }
        
        alertController.addActions(mineActions)
        
        alertController.addActions([
            saveCommentAction,
            shareAction,
            reportAction,
            UIAlertAction.cancelAction
        ])
        
        viewController.present(alertController, animated: true)
    }
    
    func showMoreInReply(
        on viewController: InboxRepliesViewController,
        coordinator: BaseCoordinator,
        reply: LMModels.Views.CommentView,
        updateCompletion: @escaping ((LMModels.Views.CommentView) -> Void)
    ) {
        let alertController = createActionSheetController(vc: viewController)
        
        let saveCommentAction = self.createSaveCommentAction(commentId: reply.id,
                                                             saved: reply.saved,
                                                             completion: updateCompletion)
        let sendMessageAction = UIAlertAction(title: "alert-send-message".localized, style: .default) { _ in
            let recipientId = reply.creator.id
            viewController.coordinator?.goToWriteMessage(recipientId: recipientId)
        }
        
        let reportAction = UIAlertAction(title: "alert-report".localized, style: .destructive) { _ in
            
            ContinueIfLogined(on: viewController, coordinator: coordinator) {
                self.reportComment(over: viewController, contentId: reply.comment.id)
            }
        }
        
        alertController.addActions([
            saveCommentAction,
            sendMessageAction,
            reportAction,
            UIAlertAction.cancelAction
        ])
        viewController.present(alertController, animated: true)
    }
    
    func showMoreInUserMention(
        on viewController: InboxMentionsViewController,
        coordinator: BaseCoordinator,
        mention: LMModels.Views.PersonMentionView
//        updateCompletion: @escaping ((LMModels.Views.CommentView) -> Void)
    ) {
        let alertController = createActionSheetController(vc: viewController)
        
        let saveCommentAction = self.createSaveCommentAction(commentId: mention.id,
                                                             saved: mention.saved,
                                                             completion: { _ in })
        let sendMessageAction = UIAlertAction(title: "alert-send-message".localized, style: .default) { _ in
            let recipientId = mention.creator.id
            viewController.coordinator?.goToWriteMessage(recipientId: recipientId)
        }
        
        alertController.addActions([
            saveCommentAction,
            sendMessageAction,
            UIAlertAction.cancelAction
        ])
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
    
    private func createShareAction(on viewController: UIViewController, toEndpoint endpoint: String) -> UIAlertAction {
        return UIAlertAction.createShareAction(title: "alert-share".localized, on: viewController, toEndpoint: endpoint)
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
    
    private func createSavePostAction(
        postId: Int,
        saved: Bool,
        completion: @escaping ((LMModels.Views.PostView) -> Void)
    ) -> UIAlertAction {
        if !saved {
            return UIAlertAction(title: "Save", style: .default) { _ in
                self.savePost(postId: postId, toSave: true, completion: completion)
            }
        } else {
            return UIAlertAction(title: "Unsave", style: .default) { _ in
                self.savePost(postId: postId, toSave: false, completion: completion)
            }
        }
    }
    
    private func createSaveCommentAction(
        commentId: Int,
        saved: Bool,
        completion: @escaping ((LMModels.Views.CommentView) -> Void)
    ) -> UIAlertAction {
        if !saved {
            return UIAlertAction(title: "Save", style: .default) { _ in
                self.saveComment(commentId: commentId, toSave: true, completion: completion)
            }
        } else {
            return UIAlertAction(title: "Unsave", style: .default) { _ in
                self.saveComment(commentId: commentId, toSave: false, completion: completion)
            }
        }
    }
    
    fileprivate func mineCommentActions<T: UIViewController>(
        comment: LMModels.Source.Comment,
        coordinator: GenericCoordinator<T>
    ) -> [UIAlertAction] {
        if isMineUser(creatorId: comment.creatorId) {
            let editAction = UIAlertAction(title: "Edit", style: .default) { _ in
                coordinator.goToEditComment(comment: comment) {
                    LMMMessagesToast.showSuccessEditComment()
                }
            }
            
            return [editAction]
        }
        
        return []
    }
    
    fileprivate func minePostActions<T: UIViewController>(
        post: LMModels.Source.Post,
        coordinator: GenericCoordinator<T>,
        completion: @escaping ((LMModels.Views.PostView) -> Void)
    ) -> [UIAlertAction] {
        if isMineUser(creatorId: post.creatorId) {
            
            let editAction = UIAlertAction(title: "Edit", style: .default) { _ in
                coordinator.goToEditPost(post: post) {
                    LMMMessagesToast.showSuccessEditPost()
                }
            }
            
            let deleteAction: UIAlertAction
            if !post.deleted {
                deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                    self.deletePost(postId: post.id, toDelete: true, completion: completion)
                }
            } else {
                deleteAction = UIAlertAction(title: "Restore", style: .destructive) { _ in
                    self.deletePost(postId: post.id, toDelete: false, completion: completion)
                }
            }
            
            return [editAction, deleteAction]
            
        }
        
        return []
    }
    
    fileprivate func reportPost(over viewController: UIViewController, post: LMModels.Source.Post) {
        self.showAlertWithTextField(over: viewController) { reportReason in
            
            guard let jwtToken = LemmyShareData.shared.jwtToken else {
                return
            }
            let params = LMModels.Api.Post.CreatePostReport(postId: post.id,
                                                            reason: reportReason,
                                                            auth: jwtToken)
            
            self.networkService
                .asyncCreatePostReport(parameters: params)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    Logger.logCombineCompletion(completion)
                } receiveValue: { _ in
                    self.showWasReportedAlert(over: viewController)
                }.store(in: &self.cancellables)
        }
    }
    
    fileprivate func reportComment(over viewController: UIViewController, contentId: Int) {
        self.showAlertWithTextField(over: viewController) { reportReason in
            
            guard let jwtToken = LemmyShareData.shared.jwtToken else {
                return
            }
            let params = LMModels.Api.Comment.CreateCommentReport(
                commentId: contentId,
                reason: reportReason,
                auth: jwtToken
            )
            
            self.networkService.asyncCreateCommentReport(parameters: params)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    Logger.logCombineCompletion(completion)
                } receiveValue: { response in
                    
                    if response.success {
                        self.showWasReportedAlert(over: viewController)
                    }
                    
                }.store(in: &self.cancellables)
        }
    }
    
    private func savePost(
        postId: Int,
        toSave: Bool,
        completion: @escaping ((LMModels.Views.PostView) -> Void)
    ) {
        guard let jwtToken = LemmyShareData.shared.jwtToken else {
            return
        }

        self.networkService.asyncSavePost(parameters: .init(postId: postId, save: toSave, auth: jwtToken))
            .receive(on: DispatchQueue.main)
            .sink { completion in
                Logger.logCombineCompletion(completion)
                if case .failure = completion {
                    LMMMessagesToast.showErrorSavePost()
                }
            } receiveValue: { response in
                completion(response.postView)
                LMMMessagesToast.showSuccessSavePost()
            }.store(in: &cancellables)
    }
    
    private func saveComment(
        commentId: Int,
        toSave: Bool,
        completion: @escaping ((LMModels.Views.CommentView) -> Void)
    ) {
        guard let jwtToken = LemmyShareData.shared.jwtToken else {
            return
        }

        self.networkService.asyncSaveComment(parameters: .init(commentId: commentId, save: toSave, auth: jwtToken))
            .receive(on: DispatchQueue.main)
            .sink { completion in
                Logger.logCombineCompletion(completion)
                if case .failure = completion {
                    LMMMessagesToast.showErrorSaveComment()
                }
            } receiveValue: { response in
                completion(response.commentView)
                LMMMessagesToast.showSuccessSaveComment()
            }.store(in: &cancellables)
    }
    
    private func deletePost(
        postId: Int,
        toDelete: Bool,
        completion: @escaping ((LMModels.Views.PostView) -> Void)
    ) {
        guard let jwtToken = LemmyShareData.shared.jwtToken else {
            return
        }
        
        self.networkService.asyncDeletePost(parameters: .init(postId: postId, deleted: toDelete, auth: jwtToken))
            .receive(on: DispatchQueue.main)
            .sink { completion in
                Logger.logCombineCompletion(completion)
                if case .failure = completion {
                    LMMMessagesToast.showErrorDeletePost()
                }
            } receiveValue: { response in
                completion(response.postView)
                LMMMessagesToast.showSuccessDeletePost()
            }.store(in: &cancellables)
    }
    
    private func isMineUser(creatorId: Int) -> Bool {
        if userAccountService.currentUserPersonID == creatorId {
            return true
        }
        
        return false
    }
}
