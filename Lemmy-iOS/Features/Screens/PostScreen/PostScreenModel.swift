//
//  PostScreenModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/2/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol PostScreenViewModelProtocol: AnyObject {
    func doPostFetch()
}

class PostScreenViewModel: PostScreenViewModelProtocol {
    weak var viewController: PostScreenViewControllerProtocol?
    
    var commentsLoaded: (([LemmyModel.CommentView]) -> Void)?

    let postInfo: LemmyModel.PostView?
    let postId: Int

    init(postId: Int, postInfo: LemmyModel.PostView?) {
        self.postInfo = postInfo
        self.postId = postId
    }

    func doPostFetch() {
        let parameters = LemmyModel.Post.GetPostRequest(id: postId,
                                                        auth: LemmyShareData.shared.jwtToken)

        ApiManager.shared.requestsManager.getPost(
            parameters: parameters
        ) { [self] (res: Result<LemmyModel.Post.GetPostResponse, LemmyGenericError>) in

            switch res {
            case .success(let data):
                self.viewController?.displayPost(
                    response: .init(state: .result(data: .init(post: data.post,
                                                               comments: data.comments)))
                    )
                commentsLoaded?(data.comments)

            case .failure(let error):
                print(error)
            }
        }
    }
}

enum PostScreen {
    
    enum PostLoad {
        
        struct Response {
            let postId: ViewControllerState
        }
        
        struct ViewModel {
            let state: ViewControllerState
        }
    }
    
    // States
    enum ViewControllerState {
        case loading
        case result(data: PostScreenViewController.View.ViewData)
    }
}
