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
    
    private let parentComment: LemmyModel.CommentView?
    private let postId: Int
    
    private let userAccountService: UserAccountSerivceProtocol
    
    private var cancellable = Set<AnyCancellable>()
    
    init(
        parentComment: LemmyModel.CommentView?,
        postId: Int,
        userAccountService: UserAccountSerivceProtocol
    ) {
        self.parentComment = parentComment
        self.postId = postId
        self.userAccountService = userAccountService
    }

    func doWriteCommentFormLoad(request: WriteComment.FormLoad.Request) {
        self.viewController?.displayWriteCommentForm(viewModel: .init(parrentCommentText: self.parentComment?.content))
    }
    
    func doRemoveCreateComment(request: WriteComment.RemoteCreateComment.Request) {
        guard let jwtToken = userAccountService.jwtToken else {
            Logger.commonLog.error("JWT Token not found: User should not be able to write comment when not authed")
            return
        }
        
        let params = LemmyModel.Comment.CreateCommentRequest(content: request.text,
                                                             parentId: parentComment?.id,
                                                             postId: postId,
                                                             formId: nil,
                                                             auth: jwtToken)
        
        ApiManager.requests.asyncCreateComment(parameters: params)
            .receive(on: RunLoop.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)

                if case .failure(let error) = completion {
                    self.viewController?.displayCreatePostError(
                        viewModel: .init(error: error.description)
                    )
                }
            } receiveValue: { (response) in
                self.viewController?.displaySuccessCreatingComment(viewModel: .init(comment: response.comment))
            }.store(in: &self.cancellable)
    }
}

enum WriteComment {
    enum FormLoad {
        struct Request { }
        
        struct ViewModel {
            let parrentCommentText: String?
        }
    }
    
    enum RemoteCreateComment {
        struct Request {
            let text: String
        }
        
        struct ViewModel {
            let comment: LemmyModel.CommentView
        }
    }
    
    enum CreateCommentError {
        struct Request { }
        
        struct ViewModel {
            let error: String
        }
    }
}
