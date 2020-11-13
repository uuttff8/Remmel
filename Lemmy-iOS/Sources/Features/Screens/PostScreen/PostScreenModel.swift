//
//  PostScreenModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/2/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class PostScreenModel {
    var commentsLoaded: (([LemmyModel.CommentView]) -> Void)?

    let postInfo: LemmyModel.PostView

    init(post: LemmyModel.PostView) {
        self.postInfo = post
    }

    func loadComments() {
        let parameters = LemmyModel.Post.GetPostRequest(id: postInfo.id,
                                                             auth: nil)

        ApiManager.shared.requestsManager.getPost(
            parameters: parameters
        ) { [self] (res: Result<LemmyModel.Post.GetPostResponse, LemmyGenericError>) in

            switch res {
            case .success(let data):
                commentsLoaded?(data.comments)

            case .failure(let error):
                print(error)
            }
        }
    }
}
