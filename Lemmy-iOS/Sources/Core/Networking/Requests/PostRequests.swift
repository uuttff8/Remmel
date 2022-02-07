//
//  PostRequests.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation
import Combine

extension RequestsManager {
    func asyncGetPost(
        parameters: LMModels.Api.Post.GetPost
    ) -> AnyPublisher<LMModels.Api.Post.GetPostResponse, LemmyGenericError> {
        
        asyncRequestDecodable(path: WSEndpoint.Post.getPost.endpoint,
                              parameters: parameters)
    }
    
    func asyncCreatePost(
        parameters: LMModels.Api.Post.CreatePost
    ) -> AnyPublisher<LMModels.Api.Post.PostResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Post.createPost.endpoint, parameters: parameters)
    }
    
    func asyncEditPost(
        parameters: LMModels.Api.Post.EditPost
    ) -> AnyPublisher<LMModels.Api.Post.PostResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Post.editPost.endpoint, parameters: parameters)
    }
    
    func asyncDeletePost(
        parameters: LMModels.Api.Post.DeletePost
    ) -> AnyPublisher<LMModels.Api.Post.PostResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Post.deletePost.endpoint, parameters: parameters)
    }
    
    func asyncSavePost(
        parameters: LMModels.Api.Post.SavePost
    ) -> AnyPublisher<LMModels.Api.Post.PostResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Post.savePost.endpoint, parameters: parameters)
    }
    
    func asyncGetPosts(
        parameters: LMModels.Api.Post.GetPosts
    ) -> AnyPublisher<LMModels.Api.Post.GetPostsResponse, LemmyGenericError> {
        
        return asyncRequestDecodable(path: WSEndpoint.Post.getPosts.endpoint, parameters: parameters)
    }
    
    func asyncCreatePostLike(
        parameters: LMModels.Api.Post.CreatePostLike
    ) -> AnyPublisher<LMModels.Api.Post.PostResponse, LemmyGenericError> {
        
        asyncRequestDecodable(path: WSEndpoint.Post.createPostLike.endpoint, parameters: parameters)
    }
    
    func asyncCreatePostReport(
        parameters: LMModels.Api.Post.CreatePostReport
    ) -> AnyPublisher<LMModels.Api.Post.PostReportResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Post.createPostReport.endpoint, parameters: parameters)
    }
    
    func asyncResolvePostReport(
        parameters: LMModels.Api.Post.ResolvePostReport
    ) -> AnyPublisher<LMModels.Api.Post.PostReportResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Post.resolvePostReport.endpoint, parameters: parameters)
    }
    
    func asyncListPostReportsRequest(
        parameters: LMModels.Api.Post.ListPostReports
    ) -> AnyPublisher<LMModels.Api.Post.ListPostReportsResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Post.listPostReports.endpoint, parameters: parameters)
    }
}
