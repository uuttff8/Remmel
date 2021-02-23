//
//  PostScreenModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/2/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

protocol PostScreenViewModelProtocol: AnyObject {
    func doPostFetch()
    func doReceiveMessages()
}

class PostScreenViewModel: PostScreenViewModelProtocol {
    weak var viewController: PostScreenViewControllerProtocol?
    
    private weak var wsClient: WSClientProtocol?
    
    private var cancellable = Set<AnyCancellable>()
    
    let postInfo: LMModels.Views.PostView?
    let postId: Int
    
    init(
        postId: Int,
        postInfo: LMModels.Views.PostView?,
        wsClient: WSClientProtocol?
    ) {
        self.postInfo = postInfo
        self.postId = postId
        self.wsClient = wsClient
    }
    
    func doPostFetch() {
        let parameters = LMModels.Api.Post.GetPost(id: self.postId,
                                                   auth: LemmyShareData.shared.jwtToken)
        
        self.wsClient?.send(LMMUserOperation.GetPost, parameters: parameters)
    }
    
    func doReceiveMessages() {
        sendPostJoin()
        
        wsClient?.onTextMessage.addObserver(self, completionHandler: { [weak self] (operation, data) in
            guard let self = self else { return }
            
            switch operation {
            case LMMUserOperation.CreateComment.rawValue:
                guard let newComment = self.wsClient?.decodeWsType(
                    LMModels.Api.Comment.CommentResponse.self,
                    data: data
                ) else { return }
                                
                DispatchQueue.main.async {
                    // Necessary since it might be a user reply, which has the recipients, to avoid double
                    if newComment.recipientIds.count == 0 {
                        self.viewController?.displayCreatedComment(viewModel: .init(comment: newComment.commentView))
                    }
                }
                
            case LMMUserOperation.EditPost.rawValue,
                 LMMUserOperation.DeletePost.rawValue,
                 LMMUserOperation.RemovePost.rawValue,
                 LMMUserOperation.LockPost.rawValue,
                 LMMUserOperation.StickyPost.rawValue,
                 LMMUserOperation.SavePost.rawValue,
                 LMMUserOperation.CreatePostLike.rawValue:
                
                guard let newPost = self.wsClient?.decodeWsType(
                    LMModels.Api.Post.PostResponse.self,
                    data: data
                ) else { return }
                
                DispatchQueue.main.async {
                    self.viewController?.displayOnlyPost(viewModel: .init(postView: newPost.postView))
                }
                
            case LMMUserOperation.EditComment.rawValue,
                 LMMUserOperation.DeleteComment.rawValue,
                 LMMUserOperation.RemoveComment.rawValue:
                
                guard let newComment = self.wsClient?.decodeWsType(
                    LMModels.Api.Comment.CommentResponse.self,
                    data: data
                ) else { return }
                
                DispatchQueue.main.async {
                    self.viewController?.displayUpdateComment(
                        viewModel: .init(commentView: newComment.commentView)
                    )
                }
                
            case LMMUserOperation.GetPost.rawValue:
                guard let newPost = self.wsClient?.decodeWsType(
                    LMModels.Api.Post.GetPostResponse.self,
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
        let commJoin = LMModels.Api.Websocket.PostJoin(postId: self.postId)
        
        wsClient?.send(
            LMMUserOperation.PostJoin.rawValue,
            parameters: commJoin
        )
    }
    
    private func makeViewData(
        from data: LMModels.Api.Post.GetPostResponse
    ) -> PostScreenViewController.View.ViewData {
        let comments = CommentTreeBuilder(comments: data.comments)
            .createCommentsTree()
        
        return .init(post: data.postView, comments: comments)
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
            let postView: LMModels.Views.PostView
        }
    }
    
    enum UpdateComment {
        struct ViewModel {
            let commentView: LMModels.Views.CommentView
        }
    }
    
    enum CreateCommentLike {
        struct ViewModel {
            let commentView: LMModels.Views.CommentView
        }
    }
    
    enum SavePost {
        struct Request { }
        
        struct ViewModel {
            let post: LMModels.Views.PostView
        }
    }
    
    enum SaveComment {
        struct Request { }
        
        struct ViewModel {
            let comment: LMModels.Views.CommentView
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
            let comment: LMModels.Views.CommentView
        }
    }
    
    // States
    enum ViewControllerState {
        case loading
        case result(data: PostScreenViewController.View.ViewData)
    }
}
