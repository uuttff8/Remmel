//
//  EditPostViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 19.02.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine
import RMModels
import RMServices
import RMNetworking
import RMFoundation

protocol EditPostViewModelProtocol: AnyObject {
    func doReceiveMessages()
    func doEditPostFormLoad(request: EditPost.FormLoad.Request)
    func doRemoteEditPost(request: EditPost.RemoteEditPost.Request)
    func doRemoteLoadImage(request: EditPost.RemoteLoadImage.Request)
}

class EditPostViewModel: EditPostViewModelProtocol {
    weak var viewController: EditPostViewControllerProtocol?
    
    private weak var wsClient: WSClientProtocol?
    
    private let postSource: RMModel.Source.Post
    
    private let userAccountService: UserAccountSerivceProtocol
    
    private var cancellable = Set<AnyCancellable>()
    
    init(
        postSource: RMModel.Source.Post,
        userAccountService: UserAccountSerivceProtocol,
        wsClient: WSClientProtocol
    ) {
        self.postSource = postSource
        self.userAccountService = userAccountService
        self.wsClient = wsClient
    }
    
    func doReceiveMessages() {
//        self.wsClient?.onTextMessage.addObserver(self, completionHandler: { [weak self] (operation, data) in
//            guard let self = self else { return }
//            
//            switch operation {
//            case RMUserOperation.EditPost.rawValue:
//                DispatchQueue.main.async {
//                    <#code#>
//                }
//            default: break
//            }
//        })
    }
    
    func doEditPostFormLoad(request: EditPost.FormLoad.Request) {
        let headerText = FormatterHelper.newMessagePostHeaderText(name: postSource.name, body: postSource.body)
        
        self.viewController?.displayEditPostForm(
            viewModel: .init(headerText: headerText,
                             name: self.postSource.name,
                             body: self.postSource.body,
                             url: self.postSource.url,
                             nsfw: self.postSource.nsfw)
        )
    }
    
    func doRemoteEditPost(request: EditPost.RemoteEditPost.Request) {
        guard let jwtToken = userAccountService.jwtToken else {
            debugPrint("JWT Token not found: User should not be able to edit post when not authed")
            return
        }
        
        let params = RMModel.Api.Post.EditPost(postId: self.postSource.id,
                                                name: request.name,
                                                url: request.url,
                                                body: request.body,
                                                nsfw: request.nsfw,
                                                auth: jwtToken)
        
        ApiManager.requests.asyncEditPost(parameters: params)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                Logger.logCombineCompletion(completion)
                
                if case .failure(let error) = completion {
                    self.viewController?.displayEditPostError(
                        viewModel: .init(error: error.description)
                    )
                }
            } receiveValue: { response in
                self.viewController?.displaySuccessEditingPost(
                    viewModel: .init(postView: response.postView)
                )
            }.store(in: &cancellable)
    }
    
    func doRemoteLoadImage(request: EditPost.RemoteLoadImage.Request) {
        
        ApiManager.requests.uploadPictrs(
            image: request.image,
            filename: request.filename
        ) { result in
            switch result {
            case .success(let response):
                guard let file = response.files.first?.file else {
                    return
                }

                self.viewController?.displayUrlLoadImage(
                    viewModel: .init(url: String.makePathToPictrs(file))
                )
            case .failure(let error):
                debugPrint(error)
                self.viewController?.displayErrorUrlLoadImage(viewModel: .init())
            }
        }
    }
}

enum EditPost {
    enum FormLoad {
        struct Request { }
        
        struct ViewModel {
            let headerText: String
            let name: String
            let body: String?
            let url: String?
            let nsfw: Bool
        }
    }
    
    enum RemoteEditPost {
        struct Request {
            let name: String
            let body: String?
            let url: String?
            let nsfw: Bool
        }
        
        struct ViewModel {
            let postView: RMModel.Views.PostView
        }
    }
    
    enum CreatePostError {
        struct Request { }
        
        struct ViewModel {
            let error: String
        }
    }
    
    enum RemoteLoadImage {
        struct Request {
            let image: UIImage
            let filename: String
        }
        
        struct ViewModel {
            let url: String
        }
    }
    
    enum ErrorRemoteLoadImage {
        struct Request { }
        
        struct ViewModel { }
    }
}
