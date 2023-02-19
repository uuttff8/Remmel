//
//  GenericCoordinator+Comment.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 08/10/2022.
//  Copyright © 2022 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMModels

extension GenericCoordinator {
    func goToWriteComment(
        postSource: RMModel.Source.Post,
        parrentComment: RMModel.Source.Comment?,
        completion: (() -> Void)? = nil
    ) {
        ContinueIfLogined(on: rootViewController, coordinator: self) {
            // TODO(uuttff8): Move this code to another component
            let haptic = UIImpactFeedbackGenerator(style: .light)
            haptic.prepare()
            haptic.impactOccurred()
            
            goToWriteMessageWrapper(
                action: .writeComment(parentComment: parrentComment, postSource: postSource),
                completion: completion
            )
        }
    }
                    
    func goToEditComment(comment: RMModel.Source.Comment, completion: (() -> Void)? = nil) {
        goToWriteMessageWrapper(action: .edit(comment: comment), completion: completion)
    }
    
    func goToWriteMessage(recipientId: Int, completion: (() -> Void)? = nil) {
        goToWriteMessageWrapper(action: .replyToPrivateMessage(recipientId: recipientId), completion: completion)
    }
    
    private func goToWriteMessageWrapper(action: WriteMessageAssembly.Action, completion: (() -> Void)? = nil) {
        let assembly = WriteMessageAssembly(action: action)
        let module = assembly.makeModule()
        module.completionHandler = completion
        
        let navigationController = StyledNavigationController(rootViewController: module)
        navigationController.presentationController?.delegate = module
        
        rootViewController.present(navigationController, animated: true)
    }
}
