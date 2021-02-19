//
//  PostScreenAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 13.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class PostScreenAssembly: Assembly {
    
    private let postId: Int
    private let postInfo: LMModels.Views.PostView? // show post if have pre-generated
    private let scrollToComment: LMModels.Views.CommentView?
    
    init(
        postId: Int,
        postInfo: LMModels.Views.PostView? = nil,
        scrollToComment: LMModels.Views.CommentView? = nil
    ) {
        self.postId = postId
        self.postInfo = postInfo
        self.scrollToComment = scrollToComment
    }
    
    func makeModule() -> PostScreenViewController {
        let viewModel = PostScreenViewModel(
            postId: self.postId,
            postInfo: self.postInfo
        )
        
        let vc = PostScreenViewController(
            viewModel: viewModel,
            scrollToComment: scrollToComment,
            contentScoreService: ContentScoreService(userAccountService: UserAccountService()),
            showMoreHandlerService: ShowMoreHandlerService()
        )
        viewModel.viewController = vc
        
        return vc
    }
}
