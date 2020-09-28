//
//  PostScreenViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/26/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class PostScreenViewController: UIViewController {
    let postInfo: LemmyApiStructs.PostView
    
    lazy var customView = PostScreenUI(post: postInfo)
    
    override func loadView() {
        self.view = customView
    }
    
    init(post: LemmyApiStructs.PostView) {
        self.postInfo = post
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        let parameters = LemmyApiStructs.Post.GetPostRequest(id: postInfo.id,
                                                             auth: nil)
        
        ApiManager.shared.requestsManager.getPost(parameters: parameters) { (res: Result<LemmyApiStructs.Post.GetPostResponse, Error>) in
            switch res {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}
