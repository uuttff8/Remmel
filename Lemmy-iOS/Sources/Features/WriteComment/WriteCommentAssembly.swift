//
//  WriteCommentAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 09.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class WriteCommentAssembly: Assembly {
    
    private let parentComment: LMModels.Views.CommentView?
    private let postSource: LMModels.Source.Post
    
    init(parentComment: LMModels.Views.CommentView?, postSource: LMModels.Source.Post) {
        self.parentComment = parentComment
        self.postSource = postSource
    }
    
    func makeModule() -> WriteCommentViewController {
        let viewModel = WriteCommentViewModel(parentComment: parentComment,
                                              postSource: postSource,
                                              userAccountService: UserAccountService())
        let vc = WriteCommentViewController(viewModel: viewModel)
        viewModel.viewController = vc
        
        return vc
    }
}
