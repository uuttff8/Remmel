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
    func doRemoteLoadImage(request: CreatePost.RemoteLoadImage.Request)
}

class CreatePostViewModel: CreatePostViewModelProtocol {
    
    weak var viewController: CreatePostScreenViewControllerProtocol?
    
    private var cancellable = Set<AnyCancellable>()
    
    func doCreatePostLoad(request: CreatePost.CreatePostLoad.Request) {
        self.viewController?.displayCreatingPost(viewModel: .init())
    }
    
    func doRemoteCreatePost(request: CreatePost.RemoteCreatePost.Request) {
        guard let jwtToken = LemmyShareData.shared.jwtToken else { return }
        
        let params = LMModels.Api.Post.CreatePost(
            name: request.title,
            url: request.url,
            body: request.body,
            nsfw: request.nsfw,
            communityId: request.communityId,
            auth: jwtToken,
            honeypot: nil
        )
        
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
                    viewModel: .init(post: response.postView)
                )
                
            }.store(in: &cancellable)
    }
    
    func doRemoteLoadImage(request: CreatePost.RemoteLoadImage.Request) {
        
        ApiManager.requests.uploadPictrs(
            image: request.image,
            filename: request.filename
        ) { (result) in
            switch result {
            case .success(let response):
                self.viewController?.displayUrlLoadImage(
                    viewModel: .init(url: String.makePathToPictrs(response.files.first!.file))
                )
            case .failure(let error):
                Logger.common.error(error)
                self.viewController?.displayErrorUrlLoadImage(viewModel: .init())
            }
        }
    }
}
