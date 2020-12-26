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
    private let postInfo: LemmyModel.PostView? // show post if have pre-generated
    private let scrollToComment: LemmyModel.CommentView?
    
    init(
        postId: Int,
        postInfo: LemmyModel.PostView? = nil,
        scrollToComment: LemmyModel.CommentView? = nil
    ) {
        self.postId = postId
        self.postInfo = postInfo
        self.scrollToComment = scrollToComment
    }
    
    func makeModule() -> PostScreenViewController {
        let viewModel = PostScreenViewModel(
            postId: self.postId,
            postInfo: self.postInfo,
            contentScoreService: ContentScoreService(
                voteService: UpvoteDownvoteRequestService(
                    userAccountService: UserAccountService()
                )
            )
        )
        
        let vc = PostScreenViewController(
            viewModel: viewModel,
            scrollToComment: scrollToComment
        )
        viewModel.viewController = vc
        
        return vc
    }
}
