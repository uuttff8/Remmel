//
//  CreatePostModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 20.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

protocol CreatePostViewModelProtocol: AnyObject {
    func doCreatePostLoad(request: CreatePost.CreatePostLoad.Request)
    func doRemoteCreatePost(request: CreatePost.RemoteCreatePost.Request)
}

class CreatePostViewModel: CreatePostViewModelProtocol {
    
    weak var viewController: CreatePostScreenViewControllerProtocol?
    
    private var cancellable = Set<AnyCancellable>()
    
    func doCreatePostLoad(request: CreatePost.CreatePostLoad.Request) {
        self.viewController?.displayCreatingPost(viewModel: .init())
    }
    
    func doRemoteCreatePost(request: CreatePost.RemoteCreatePost.Request) {
        guard let jwtToken = LemmyShareData.shared.jwtToken else { return }
        
        let params = LemmyModel.Post.CreatePostRequest(name: request.title,
                                                       url: request.url,
                                                       body: request.body,
                                                       nsfw: request.nsfw,
                                                       communityId: request.communityId,
                                                       auth: jwtToken)
        
        ApiManager.requests.asyncCreatePost(parameters: params)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)

                if case .failure(let error) = completion {
                    self.viewController?.displayCreatePostError(
                        viewModel: .init(error: error.description)
                    )
                }
            } receiveValue: { (response) in
                
                self.viewController?.displaySuccessCreatingPost(
                    viewModel: .init(post: response.post)
                )
                
            }.store(in: &cancellable)
    }
}
