//
//  PostScreenModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/2/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class PostScreenModel {
    var commentsLoaded: ((Array<LemmyApiStructs.CommentView>) -> Void)?
    
    let postInfo: LemmyApiStructs.PostView
    
    init(post: LemmyApiStructs.PostView) {
        self.postInfo = post
    }
    
    func loadComments() {
        let parameters = LemmyApiStructs.Post.GetPostRequest(id: postInfo.id,
                                                             auth: nil)
        
        ApiManager.shared.requestsManager.getPost(parameters: parameters) { [self]
            (res: Result<LemmyApiStructs.Post.GetPostResponse, Error>) in
            
            switch res {
            case .success(let data):                
                commentsLoaded?(data.comments)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
