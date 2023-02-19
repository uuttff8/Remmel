//
//  ShowMoreAlerting.swift
//  Remmel
//
//  Created by uuttff8 on 17/01/2023.
//  Copyright © 2023 Anton Kuzmin. All rights reserved.
//

import Foundation
import RMModels
import UIKit

protocol ShowMoreAlerting {
    func showMoreInPost(
        isDeleted: Bool,
        isMineActions: Bool,
        isSaved: Bool,
        editAction: @escaping () -> Void,
        deleteAction: @escaping () -> Void,
        saveAction: @escaping () -> Void,
        reportAction: @escaping () -> Void
    )
    func showMoreInComment(
        isSaved: Bool,
        editAction: @escaping () -> Void,
        saveAction: @escaping () -> Void,
        reportAction: @escaping () -> Void
    )
    func showMoreInReply(
        isSaved: Bool,
        saveCommentAction: @escaping () -> Void,
        sendMessageAction: @escaping () -> Void,
        reportAction: @escaping () -> Void
    )
    func showMoreInUserMention(
        isSaved: Bool,
        saveAction: @escaping () -> Void,
        sendMessageAction: @escaping () -> Void
    )
}

extension ShowMoreAlerting where Self: UIViewController {
    func showMoreInPost(
        isDeleted: Bool,
        isMineActions: Bool,
        isSaved: Bool,
        editAction: @escaping () -> Void,
        deleteAction: @escaping () -> Void,
        saveAction: @escaping () -> Void,
        reportAction: @escaping () -> Void
    ) {
        let mineActions = minePostActions(isDeleted: isDeleted, editAction: editAction, deleteAction: deleteAction)
        
        let alertController = createActionSheetController(vc: self)
        let savePostAction = createSaveAction(saved: isSaved, completion: saveAction)
//        let shareAction = createShareAction(on: self, toEndpoint: post.post.apId)
        
        let reportAction = UIAlertAction(title: "alert-report".localized, style: .destructive) { _ in
            reportAction()
//            ContinueIfLogined(on: viewController, coordinator: coordinator) {
//                self.reportPost(over: viewController, post: post.post)
//            }
        }
        
        if isMineActions {
            alertController.addActions(mineActions)
        }
        
        alertController.addActions([
            savePostAction,
//            shareAction,
            reportAction,
            UIAlertAction.cancelAction
        ])
        
        present(alertController, animated: true)
    }
    
    func showMoreInComment(
        isSaved: Bool,
        editAction: @escaping () -> Void,
        saveAction: @escaping () -> Void,
        reportAction: @escaping () -> Void
    ) {
        let alertController = createActionSheetController(vc: self)
        
        let mineActions = mineCommentActions(editAction: editAction)
        let saveCommentAction = createSaveAction(saved: isSaved, completion: saveAction)
//        let shareAction = createShareAction(on: viewController, toEndpoint: comment.getApIdRelatedToPost())
        let reportAction = UIAlertAction(title: "alert-report".localized, style: .destructive) { _ in
            reportAction()
        }
        
        alertController.addActions(mineActions)
        
        alertController.addActions([
            saveCommentAction,
//            share,
            reportAction,
            UIAlertAction.cancelAction
        ])
        
        present(alertController, animated: true)
    }
    
    func showMoreInReply(
        isSaved: Bool,
        saveCommentAction: @escaping () -> Void,
        sendMessageAction: @escaping () -> Void,
        reportAction: @escaping () -> Void
    ) {
        let alertController = createActionSheetController(vc: self)
        
        let saveCommentAction = createSaveAction(saved: isSaved, completion: saveCommentAction)
        let sendMessageAction = UIAlertAction(title: "alert-send-message".localized, style: .default) { _ in
            sendMessageAction()
        }
        
        let reportAction = UIAlertAction(title: "alert-report".localized, style: .destructive) { _ in
            reportAction()
//            ContinueIfLogined(on: viewController, coordinator: coordinator) {
//                self.reportComment(over: viewController, contentId: reply.comment.id)
//            }
        }
        
        alertController.addActions([
            saveCommentAction,
            sendMessageAction,
            reportAction,
            UIAlertAction.cancelAction
        ])
        present(alertController, animated: true)
    }
    
    func showMoreInUserMention(
        isSaved: Bool,
        saveAction: @escaping () -> Void,
        sendMessageAction: @escaping () -> Void
    ) {
        let alertController = createActionSheetController(vc: self)
        
        let saveCommentAction = createSaveAction(saved: isSaved, completion: saveAction)//(
//            commentId: mention.id,
//            saved: mention.saved,
//            completion: { _ in }
//        )
        let sendMessageAction = UIAlertAction(title: "alert-send-message".localized, style: .default) { _ in
            sendMessageAction()
//            let recipientId = mention.creator.id
//            viewController.coordinator?.goToWriteMessage(recipientId: recipientId)
        }
        
        alertController.addActions([
            saveCommentAction,
            sendMessageAction,
            UIAlertAction.cancelAction
        ])
        present(alertController, animated: true)
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
        UIAlertAction.createShareAction(title: "alert-share".localized, on: viewController, toEndpoint: endpoint)
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
                if let textFieldText = controller.textFields?.first?.text, !textFieldText.isEmpty {
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
    
    private func createSaveAction(
        saved: Bool,
        completion: @escaping () -> Void
    ) -> UIAlertAction {
        let toSave = saved ? false : true
        let saveString = saved ? "alert-unsave".localized : "alert-save".localized
        return UIAlertAction(title: "alert-save".localized, style: .default) { _ in
            completion()
        }
    }
}

func mineCommentActions(
    editAction: @escaping () -> Void
) -> [UIAlertAction] {
    let editAction = UIAlertAction(title: "Edit", style: .default) { _ in
        editAction()
//        coordinator.goToEditComment(comment: comment) {
//            RMMessagesToast.showSuccessEditComment()
//        }
    }
    
    return [editAction]
}

func minePostActions(
    isDeleted: Bool,
    editAction: @escaping () -> Void,
    deleteAction: @escaping () -> Void
) -> [UIAlertAction] {
    let editAction = UIAlertAction(title: "Edit", style: .default) { _ in
        editAction()
//            coordinator.goToEditPost(post: post) {
//                RMMessagesToast.showSuccessEditPost()
//            }
    }
        
    let deleteOrRestore = isDeleted ? "Restore" : "Delete"
    let deleteAction = UIAlertAction(title: deleteOrRestore, style: .destructive) { _ in
        deleteAction()
//            self.deletePost(postId: post.id, toDelete: true, completion: completion)
        }
    
    return [editAction, deleteAction]
}

//private func isMineUser(creatorId: Int) -> Bool {
//    userAccountService.currentUserPersonID == creatorId {
//}
