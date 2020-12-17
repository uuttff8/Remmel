//
//  WriteCommentAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 09.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class WriteCommentAssembly: Assembly {
    
    private let parentComment: LemmyModel.CommentView?
    private let postId: Int
    
    init(parentComment: LemmyModel.CommentView?, postId: Int) {
        self.parentComment = parentComment
        self.postId = postId
    }
    
    func makeModule() -> WriteCommentViewController {
        let viewModel = WriteCommentViewModel(parentComment: parentComment,
                                              postId: postId,
                                              userAccountService: UserAccountService())
        let vc = WriteCommentViewController(viewModel: viewModel)
        viewModel.viewController = vc
        
        return vc
    }
}
