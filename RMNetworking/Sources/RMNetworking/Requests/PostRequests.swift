//
//  PostRequests.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation
import Combine
import RMFoundation
import RMModels

public extension RequestsManager {
    func asyncGetPost(
        parameters: RMModels.Api.Post.GetPost
    ) -> AnyPublisher<RMModels.Api.Post.GetPostResponse, LemmyGenericError> {
        
        asyncRequestDecodable(path: WSEndpoint.Post.getPost.endpoint,
                              parameters: parameters)
    }
    
    func asyncCreatePost(
        parameters: RMModels.Api.Post.CreatePost
    ) -> AnyPublisher<RMModels.Api.Post.PostResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Post.createPost.endpoint, parameters: parameters)
    }
    
    func asyncEditPost(
        parameters: RMModels.Api.Post.EditPost
    ) -> AnyPublisher<RMModels.Api.Post.PostResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Post.editPost.endpoint, parameters: parameters)
    }
    
    func asyncDeletePost(
        parameters: RMModels.Api.Post.DeletePost
    ) -> AnyPublisher<RMModels.Api.Post.PostResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Post.deletePost.endpoint, parameters: parameters)
    }
    
    func asyncSavePost(
        parameters: RMModels.Api.Post.SavePost
    ) -> AnyPublisher<RMModels.Api.Post.PostResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Post.savePost.endpoint, parameters: parameters)
    }
    
    func asyncGetPosts(
        parameters: RMModels.Api.Post.GetPosts
    ) -> AnyPublisher<RMModels.Api.Post.GetPostsResponse, LemmyGenericError> {
        
        return asyncRequestDecodable(path: WSEndpoint.Post.getPosts.endpoint, parameters: parameters)
    }
    
    func asyncCreatePostLike(
        parameters: RMModels.Api.Post.CreatePostLike
    ) -> AnyPublisher<RMModels.Api.Post.PostResponse, LemmyGenericError> {
        
        asyncRequestDecodable(path: WSEndpoint.Post.createPostLike.endpoint, parameters: parameters)
    }
    
    func asyncCreatePostReport(
        parameters: RMModels.Api.Post.CreatePostReport
    ) -> AnyPublisher<RMModels.Api.Post.PostReportResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Post.createPostReport.endpoint, parameters: parameters)
    }
    
    func asyncResolvePostReport(
        parameters: RMModels.Api.Post.ResolvePostReport
    ) -> AnyPublisher<RMModels.Api.Post.PostReportResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Post.resolvePostReport.endpoint, parameters: parameters)
    }
    
    func asyncListPostReportsRequest(
        parameters: RMModels.Api.Post.ListPostReports
    ) -> AnyPublisher<RMModels.Api.Post.ListPostReportsResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Post.listPostReports.endpoint, parameters: parameters)
    }
}
