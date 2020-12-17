//
//  WriteCommentViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 09.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol WriteCommentViewModelProtocol: AnyObject {
    func doWriteCommentFormLoad(request: WriteComment.FormLoad.Request)
}

class WriteCommentViewModel: WriteCommentViewModelProtocol {
    weak var viewController: WriteCommentViewControllerProtocol?
    
    private let parentComment: LemmyModel.CommentView?
    private let postId: Int
    
    init(parentComment: LemmyModel.CommentView?, postId: Int) {
        self.parentComment = parentComment
        self.postId = postId
    }

    func doWriteCommentFormLoad(request: WriteComment.FormLoad.Request) {
        self.viewController?.displayWriteCommentForm(viewModel: .init(parrentCommentText: self.parentComment?.content))
    }
}

enum WriteComment {
    enum FormLoad {
        struct Request { }
        
        struct ViewModel {
            let parrentCommentText: String?
        }
    }
}
