//
//  WriteCommentViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 09.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

protocol WriteCommentViewModelProtocol: AnyObject {
    func doWriteCommentFormLoad(request: WriteComment.FormLoad.Request)
    func doRemoveCreateComment(request: WriteComment.RemoteCreateComment.Request)
}

class WriteCommentViewModel: WriteCommentViewModelProtocol {
    weak var viewController: WriteCommentViewControllerProtocol?
    
    private let parentComment: LMModels.Source.Comment?
    private let postSource: LMModels.Source.Post
    
    private let userAccountService: UserAccountSerivceProtocol
    
    private var cancellable = Set<AnyCancellable>()
    
    init(
        parentComment: LMModels.Source.Comment?,
        postSource: LMModels.Source.Post,
        userAccountService: UserAccountSerivceProtocol
    ) {
        self.parentComment = parentComment
        self.postSource = postSource
        self.userAccountService = userAccountService
    }
    
    func doWriteCommentFormLoad(request: WriteComment.FormLoad.Request) {
        
        let headerText: String
        if let parrentCommentText = parentComment?.content {
            headerText = parrentCommentText
        } else {
            headerText = FormatterHelper.newMessagePostHeaderText(name: postSource.name, body: postSource.body)
        }
        
        self.viewController?.displayWriteCommentForm(
            viewModel: .init(headerText: headerText)
        )
    }
    
    func doRemoveCreateComment(request: WriteComment.RemoteCreateComment.Request) {
        guard let jwtToken = userAccountService.jwtToken else {
            Logger.common.error("JWT Token not found: User should not be able to write comment when not authed")
            return
        }
        
        let params = LMModels.Api.Comment.CreateComment(content: request.text,
                                                        parentId: self.parentComment?.id,
                                                        postId: self.postSource.id,
                                                        formId: nil,
                                                        auth: jwtToken)
        
        ApiManager.requests.asyncCreateComment(parameters: params)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
                
                if case .failure(let error) = completion {
                    self.viewController?.displayCreatePostError(
                        viewModel: .init(error: error.description)
                    )
                }
            } receiveValue: { (response) in
                self.viewController?.displaySuccessCreatingComment(
                    viewModel: .init(comment: response.commentView)
                )
            }.store(in: &self.cancellable)
    }
}

enum WriteComment {
    enum FormLoad {
        struct Request { }
        
        struct ViewModel {
            let headerText: String?
        }
    }
    
    enum RemoteCreateComment {
        struct Request {
            let text: String
        }
        
        struct ViewModel {
            let comment: LMModels.Views.CommentView
        }
    }
    
    enum CreateCommentError {
        struct Request { }
        
        struct ViewModel {
            let error: String
        }
    }
}
