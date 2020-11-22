//
//  CreatePostModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 20.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol CreatePostViewModelProtocol: AnyObject {
    func doCreatePostLoad(request: CreatePost.CreatePostLoad.Request)    
}

class CreatePostViewModel: CreatePostViewModelProtocol {
    
    weak var viewController: CreatePostScreenViewControllerProtocol?
            
    // MARK: - Initializer
    init() { }
    
    func doCreatePostLoad(request: CreatePost.CreatePostLoad.Request) {
        self.viewController?.displayCreatingPost(viewModel: .init())
    }
    
    // MARK: - Api Request
    func createPost(
        data: Data,
        completion: @escaping ((Result<LemmyModel.PostView, LemmyGenericError>) -> Void)
    ) {
        // TODO handle creating post
    }
}
