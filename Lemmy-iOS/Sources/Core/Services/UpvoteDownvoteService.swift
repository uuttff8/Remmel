//
//  LikeDislikeService.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 16.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

protocol UpvoteDownvoteServiceProtocol: AnyObject {
    func likePost(postId: LemmyModel.PostView.Id) -> AnyPublisher<LemmyModel.PostView, LemmyGenericError>
    func dislikePost(postId: LemmyModel.PostView.Id) -> AnyPublisher<LemmyModel.PostView, LemmyGenericError>
    
    func undoLike(postId: LemmyModel.PostView.Id) -> AnyPublisher<LemmyModel.PostView, LemmyGenericError>
}

final class UpvoteDownvoteService: UpvoteDownvoteServiceProtocol {
    private let userAccountService: UserAccountSerivceProtocol
    
    private var cancellable = Set<AnyCancellable>()
    
    init(
        userAccountService: UserAccountSerivceProtocol
    ) {
        self.userAccountService = userAccountService
    }
    
    func likePost(postId: LemmyModel.PostView.Id) -> AnyPublisher<LemmyModel.PostView, LemmyGenericError> {
        
        guard let jwtToken = self.userAccountService.jwtToken
        else {
            return Fail(error: LemmyGenericError.string("failed to fetch jwt token"))
                .eraseToAnyPublisher()
        }
        
        let params = LemmyModel.Post.CreatePostLikeRequest(postId: postId,
                                                           score: 1,
                                                           auth: jwtToken)
        
        return ApiManager.requests.asyncCreatePostLike(parameters: params)
            .map({ $0.post })
            .eraseToAnyPublisher()
    }
    
    func dislikePost(postId: LemmyModel.PostView.Id) -> AnyPublisher<LemmyModel.PostView, LemmyGenericError> {
        
        guard let jwtToken = self.userAccountService.jwtToken
        else {
            return Fail(error: LemmyGenericError.string("failed to fetch jwt token"))
                .eraseToAnyPublisher()
        }
        
        let params = LemmyModel.Post.CreatePostLikeRequest(postId: postId,
                                                           score: -1,
                                                           auth: jwtToken)
        
        return ApiManager.requests.asyncCreatePostLike(parameters: params)
            .map({ $0.post })
            .eraseToAnyPublisher()
        
    }
    
    func undoLike(postId: LemmyModel.PostView.Id) -> AnyPublisher<LemmyModel.PostView, LemmyGenericError> {
        guard let jwtToken = self.userAccountService.jwtToken
        else {
            return Fail(error: LemmyGenericError.string("failed to fetch jwt token"))
                .eraseToAnyPublisher()
        }
        
        let params = LemmyModel.Post.CreatePostLikeRequest(postId: postId,
                                                           score: 0,
                                                           auth: jwtToken)
        
        return ApiManager.requests.asyncCreatePostLike(parameters: params)
            .map({ $0.post })
            .eraseToAnyPublisher()
    }
}
