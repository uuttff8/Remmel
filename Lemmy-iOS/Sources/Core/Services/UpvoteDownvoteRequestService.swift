//
//  LikeDislikeService.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 16.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

protocol UpvoteDownvoteRequestServiceProtocol: AnyObject {
    func like(post: LemmyModel.PostView) -> AnyPublisher<LemmyModel.PostView, LemmyGenericError>
    func dislike(post: LemmyModel.PostView) -> AnyPublisher<LemmyModel.PostView, LemmyGenericError>
    
    func undoLike(post: LemmyModel.PostView) -> AnyPublisher<LemmyModel.PostView, LemmyGenericError>
    
    func createPostLike(
        vote: LemmyVoteType,
        post: LemmyModel.PostView
    ) -> AnyPublisher<LemmyModel.PostView, LemmyGenericError>
    
    func createCommentLike(
        vote: LemmyVoteType,
        comment: LemmyModel.CommentView
    ) -> AnyPublisher<LemmyModel.CommentView, LemmyGenericError>
}

final class UpvoteDownvoteRequestService: UpvoteDownvoteRequestServiceProtocol {
    private let userAccountService: UserAccountSerivceProtocol
    
    private var cancellable = Set<AnyCancellable>()
    
    init(
        userAccountService: UserAccountSerivceProtocol
    ) {
        self.userAccountService = userAccountService
    }
    
    func like(post: LemmyModel.PostView) -> AnyPublisher<LemmyModel.PostView, LemmyGenericError> {
        
        guard let jwtToken = self.userAccountService.jwtToken
        else {
            return Fail(error: LemmyGenericError.string("failed to fetch jwt token"))
                .eraseToAnyPublisher()
        }
        
        let params = LemmyModel.Post.CreatePostLikeRequest(postId: post.id,
                                                           score: 1,
                                                           auth: jwtToken)
        
        return ApiManager.requests.asyncCreatePostLike(parameters: params)
            .map({ $0.post })
            .eraseToAnyPublisher()
    }
    
    func dislike(post: LemmyModel.PostView) -> AnyPublisher<LemmyModel.PostView, LemmyGenericError> {
        
        guard let jwtToken = self.userAccountService.jwtToken
        else {
            return Fail(error: LemmyGenericError.string("failed to fetch jwt token"))
                .eraseToAnyPublisher()
        }
        
        let params = LemmyModel.Post.CreatePostLikeRequest(postId: post.id,
                                                           score: -1,
                                                           auth: jwtToken)
        
        return ApiManager.requests.asyncCreatePostLike(parameters: params)
            .map({ $0.post })
            .eraseToAnyPublisher()
        
    }
    
    func undoLike(post: LemmyModel.PostView) -> AnyPublisher<LemmyModel.PostView, LemmyGenericError> {
        guard let jwtToken = self.userAccountService.jwtToken
        else {
            return Fail(error: LemmyGenericError.string("failed to fetch jwt token"))
                .eraseToAnyPublisher()
        }
        
        let params = LemmyModel.Post.CreatePostLikeRequest(postId: post.id,
                                                           score: 0,
                                                           auth: jwtToken)
        
        return ApiManager.requests.asyncCreatePostLike(parameters: params)
            .map({ $0.post })
            .eraseToAnyPublisher()
    }
    
    func createPostLike(
        vote: LemmyVoteType,
        post: LemmyModel.PostView
    ) -> AnyPublisher<LemmyModel.PostView, LemmyGenericError> {
        guard let jwtToken = self.userAccountService.jwtToken
        else {
            return Fail(error: LemmyGenericError.string("failed to fetch jwt token"))
                .eraseToAnyPublisher()
        }
        
        let params = LemmyModel.Post.CreatePostLikeRequest(postId: post.id,
                                                           score: vote.rawValue,
                                                           auth: jwtToken)
        
        return ApiManager.requests.asyncCreatePostLike(parameters: params)
            .map({ $0.post })
            .eraseToAnyPublisher()
    }
    
    func createCommentLike(
        vote: LemmyVoteType,
        comment: LemmyModel.CommentView
    ) -> AnyPublisher<LemmyModel.CommentView, LemmyGenericError> {
        
        guard let jwtToken = self.userAccountService.jwtToken
        else {
            return Fail(error: LemmyGenericError.string("failed to fetch jwt token"))
                .eraseToAnyPublisher()
        }
        
        let params = LemmyModel.Comment.CreateCommentLikeRequest(commentId: comment.id,
                                                                 score: vote.rawValue,
                                                                 auth: jwtToken)
        
        return ApiManager.requests.asyncCreateCommentLike(parameters: params)
            .map({ $0.comment })
            .eraseToAnyPublisher()
    }
}
