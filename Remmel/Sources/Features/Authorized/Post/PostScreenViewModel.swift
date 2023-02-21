//
//  PostScreenModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/2/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine
import RMModels
import RMNetworking
import RMFoundation

protocol PostScreenViewModelProtocol: AnyObject {
    func doPostFetch()
    func doReceiveMessages()
}

class PostScreenViewModel: PostScreenViewModelProtocol {
    weak var viewController: PostScreenViewControllerProtocol?
    
    private weak var wsClient: WSClientProtocol?
    
    private var cancellable = Set<AnyCancellable>()
    
    let postInfo: RMModels.Views.PostView?
    let postId: Int
    
    init(
        postId: Int,
        postInfo: RMModels.Views.PostView?,
        wsClient: WSClientProtocol?
    ) {
        self.postInfo = postInfo
        self.postId = postId
        self.wsClient = wsClient
    }
    
    func doPostFetch() {
        let parameters = RMModels.Api.Post.GetPost(id: self.postId,
                                                   commentId: nil,
                                                   auth: LemmyShareData.shared.jwtToken)
        
        self.wsClient?.send(RMUserOperation.GetPost, parameters: parameters)
    }
    
    func doReceiveMessages() {
        sendPostJoin()
        
        wsClient?.onTextMessage.addObserver(self, completionHandler: { [weak self] operation, data in
            guard let self = self else {
                return
            }
            
            switch operation {
            case RMUserOperation.CreateComment.rawValue:
                guard let newComment = self.wsClient?.decodeWsType(
                    RMModels.Api.Comment.CommentResponse.self,
                    data: data
                ) else { return }
                                
                DispatchQueue.main.async {
                    // Necessary since it might be a user reply, which has the recipients, to avoid double
                    if newComment.recipientIds.isEmpty {
                        self.viewController?.displayCreatedComment(viewModel: .init(comment: newComment.commentView))
                    }
                }
                
            case RMUserOperation.CreateCommentLike.rawValue:
                guard let newComment = self.wsClient?.decodeWsType(
                    RMModels.Api.Comment.CommentResponse.self,
                    data: data
                ) else { return }
                
                DispatchQueue.main.async {
                    self.viewController?.displayCreateCommentLike(viewModel: .init(commentView: newComment.commentView))
                }
                
            case RMUserOperation.EditPost.rawValue,
                 RMUserOperation.DeletePost.rawValue,
                 RMUserOperation.RemovePost.rawValue,
                 RMUserOperation.LockPost.rawValue,
                 RMUserOperation.StickyPost.rawValue,
                 RMUserOperation.SavePost.rawValue,
                 RMUserOperation.CreatePostLike.rawValue:
                
                guard let newPost = self.wsClient?.decodeWsType(
                    RMModels.Api.Post.PostResponse.self,
                    data: data
                ) else { return }
                
                DispatchQueue.main.async {
                    self.viewController?.displayOnlyPost(viewModel: .init(postView: newPost.postView))
                }
                
            case RMUserOperation.EditComment.rawValue,
                 RMUserOperation.DeleteComment.rawValue,
                 RMUserOperation.RemoveComment.rawValue:
                
                guard let newComment = self.wsClient?.decodeWsType(
                    RMModels.Api.Comment.CommentResponse.self,
                    data: data
                ) else { return }
                
                DispatchQueue.main.async {
                    self.viewController?.displayUpdateComment(
                        viewModel: .init(commentView: newComment.commentView)
                    )
                }
                
            case RMUserOperation.GetPost.rawValue:
                guard let newPost = self.wsClient?.decodeWsType(
                    RMModels.Api.Post.GetPostResponse.self,
                    data: data
                ) else { return }
                
                DispatchQueue.main.async {
                    self.viewController?.displayPostWithComments(
                        viewModel: .init(
                            state: .result(
                                data: self.makeViewData(from: newPost)
                            )
                        )
                    )
                }
                
            default:
                break
            }
        })
    }
    
    private func sendPostJoin() {
        let commJoin = RMModels.Api.Websocket.PostJoin(postId: postId)
        wsClient?.send(
            RMUserOperation.PostJoin.rawValue,
            parameters: commJoin
        )
    }
    
    private func makeViewData(
        from data: RMModels.Api.Post.GetPostResponse
    ) -> PostScreenViewController.View.ViewData {
//        let comments = CommentTreeBuilder(comments: data.comments).createCommentsTree()
        return .init(post: data.postView, comments: [])
    }
}

enum PostScreen {
    
    enum PostLoad {
        struct Response { }
        
        struct ViewModel {
            let state: ViewControllerState
        }
    }
    
    enum OnlyPostLoad {
        struct ViewModel {
            let postView: RMModels.Views.PostView
        }
    }
    
    enum UpdateComment {
        struct ViewModel {
            let commentView: RMModels.Views.CommentView
        }
    }
    
    enum CreateCommentLike {
        struct ViewModel {
            let commentView: RMModels.Views.CommentView
        }
    }
    
    enum SavePost {
        struct Request { }
        
        struct ViewModel {
            let post: RMModels.Views.PostView
        }
    }
    
    enum SaveComment {
        struct Request { }
        
        struct ViewModel {
            let comment: RMModels.Views.CommentView
        }
    }
    
    enum ToastMessage {
        struct ViewModel {
            let isSuccess: Bool
            let message: String
        }
    }
    
    enum CreateComment {
        struct ViewModel {
            let comment: RMModels.Views.CommentView
        }
    }
    
    // States
    enum ViewControllerState {
        case loading
        case result(data: PostScreenViewController.View.ViewData)
    }
}
