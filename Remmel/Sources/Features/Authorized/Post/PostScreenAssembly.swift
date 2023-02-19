//
//  PostScreenAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 13.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMModels
import RMNetworking
import RMServices

class PostScreenAssembly: Assembly {
    
    private let postId: Int
    private let postInfo: RMModel.Views.PostView? // show post if have pre-generated
    private let scrollToComment: RMModel.Views.CommentView?
    
    init(
        postId: Int,
        postInfo: RMModel.Views.PostView? = nil,
        scrollToComment: RMModel.Views.CommentView? = nil
    ) {
        self.postId = postId
        self.postInfo = postInfo
        self.scrollToComment = scrollToComment
    }
    
    func makeModule() -> PostScreenViewController {
        let viewModel = PostScreenViewModel(
            postId: self.postId,
            postInfo: self.postInfo,
            wsClient: ApiManager.chainedWsCLient
        )
        
        let vc = PostScreenViewController(
            viewModel: viewModel, 
            scrollToComment: scrollToComment,
            contentScoreService: ContentScoreService(userAccountService: UserAccountService()),
            showMoreHandlerService: ShowMoreHandlerServiceImp()
        )
        viewModel.viewController = vc
        
        return vc
    }
}
