//
//  WriteMessageViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

protocol WriteMessageViewModelProtocol: AnyObject {
    
    var action: WriteMessageAssembly.Action { get }
    
    func doWriteMessageFormLoad(request: WriteMessage.FormLoad.Request)
    func doRemoteCreateMessage(request: WriteMessage.RemoteCreateMessage.Request)
}

class WriteMessageViewModel: WriteMessageViewModelProtocol {
    weak var viewController: WriteMessageViewControllerProtocol?
    
    var action: WriteMessageAssembly.Action

    private let userAccountService: UserAccountSerivceProtocol
    
    private var cancellable = Set<AnyCancellable>()
    
    init(
        action: WriteMessageAssembly.Action,
        userAccountService: UserAccountSerivceProtocol
    ) {
        self.action = action
        self.userAccountService = userAccountService
    }

    func doWriteMessageFormLoad(request: WriteMessage.FormLoad.Request) {
        let headerText: String
        
        switch self.action {
        case .replyToPrivateMessage:
            headerText = ""
        case let .writeComment(parentComment: parentComment, postSource: postSource):
            if let parrentCommentText = parentComment?.content {
                headerText = parrentCommentText
            } else {
                headerText = FormatterHelper.newMessagePostHeaderText(name: postSource.name, body: postSource.body)
            }
        case let .edit(comment: comment):
            headerText = comment.content
        }
        
        self.viewController?.displayWriteMessageForm(viewModel: .init(headerText: headerText))
    }
        
    func doRemoteCreateMessage(request: WriteMessage.RemoteCreateMessage.Request) {
        guard let jwtToken = userAccountService.jwtToken else {
            Logger.commonLog.error("JWT Token not found: User should not be able to write message when not authed")
            return
        }
        
        switch self.action {
        case let .replyToPrivateMessage(recipientId: recipientId):
            sendReplyToAPrivateMessageRequest(auth: jwtToken, text: request.text, recipientId: recipientId)
        case let .writeComment(parentComment: parentComment, postSource: postSource):
            sendWriteCommentRequest(auth: jwtToken,
                                    parentId: parentComment?.id,
                                    postId: postSource.id,
                                    text: request.text)
        case let .edit(comment: comment):
            sendEditCommentRequest(auth: jwtToken, text: request.text, commentId: comment.id)
        }
    }
    
    private func sendReplyToAPrivateMessageRequest(auth: String, text: String, recipientId: Int) {
        let params = LMModels.Api.Person.CreatePrivateMessage(
            content: text,
            recipientId: recipientId,
            auth: auth
        )
        
        ApiManager.requests.asyncCreatePrivateMessage(parameters: params)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
                
                if case .failure(let error) = completion {
                    self.viewController?.displayCreateMessageError(
                        viewModel: .init(error: error.description)
                    )
                }
            } receiveValue: { (_) in
                self.viewController?.displaySuccessCreatingMessage(
                    viewModel: .init()
                )
            }.store(in: &self.cancellable)
    }
    
    private func sendEditCommentRequest(auth: String, text: String, commentId: Int) {
        let params = LMModels.Api.Comment.EditComment(
            content: text,
            commentId: commentId,
            formId: nil,
            auth: auth
        )
        
        ApiManager.requests.asyncEditComment(parameters: params)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
                
                if case .failure(let error) = completion {
                    self.viewController?.displayCreateMessageError(
                        viewModel: .init(error: error.description)
                    )
                }
            } receiveValue: { (_) in
                self.viewController?.displaySuccessCreatingMessage(
                    viewModel: .init()
                )
            }.store(in: &self.cancellable)
    }
    
    private func sendWriteCommentRequest(auth: String, parentId: Int?, postId: Int, text: String) {
        let params = LMModels.Api.Comment.CreateComment(content: text,
                                                        parentId: parentId,
                                                        postId: postId,
                                                        formId: nil,
                                                        auth: auth)
        
        ApiManager.requests.asyncCreateComment(parameters: params)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
                
                if case .failure(let error) = completion {
                    self.viewController?.displayCreateMessageError(
                        viewModel: .init(error: error.description)
                    )
                }
            } receiveValue: { (_) in
                self.viewController?.displaySuccessCreatingMessage(viewModel: .init())
            }.store(in: &self.cancellable)

    }
}

enum WriteMessage {
    enum FormLoad {
        struct Request { }
        
        struct ViewModel {
            let headerText: String
        }
    }
    
    enum RemoteCreateMessage {
        struct Request {
            let text: String
        }
        
        struct ViewModel { }
    }
    
    enum CreateMessageError {
        struct Request { }
        
        struct ViewModel {
            let error: String
        }
    }
}
