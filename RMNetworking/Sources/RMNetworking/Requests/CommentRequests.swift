//
//  CommentRequests.swift
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
    func asyncGetComments(
        parameters: RMModels.Api.Comment.GetComments
    ) -> AnyPublisher<RMModels.Api.Comment.GetCommentsResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Comment.getComments.endpoint, parameters: parameters)
    }
    
    func asyncCreateComment(
        parameters: RMModels.Api.Comment.CreateComment
    ) -> AnyPublisher<RMModels.Api.Comment.CommentResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Comment.createComment.endpoint, parameters: parameters)
    }
    
    func asyncEditComment(
        parameters: RMModels.Api.Comment.EditComment
    ) -> AnyPublisher<RMModels.Api.Comment.CommentResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Comment.editComment.endpoint, parameters: parameters)
    }
    
    func asyncDeleteComment(
        parameters: RMModels.Api.Comment.DeleteComment
    ) -> AnyPublisher<RMModels.Api.Comment.CommentResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Comment.deleteComment.endpoint, parameters: parameters)
    }
    
    func asyncRemoveComment(
        parameters: RMModels.Api.Comment.RemoveComment
    ) -> AnyPublisher<RMModels.Api.Comment.CommentResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Comment.removeComment.endpoint, parameters: parameters)
    }
        
    func asyncSaveComment(
        parameters: RMModels.Api.Comment.SaveComment
    ) -> AnyPublisher<RMModels.Api.Comment.CommentResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Comment.saveComment.endpoint, parameters: parameters)
    }
    
    func asyncCreateCommentLike(
        parameters: RMModels.Api.Comment.CreateCommentLike
    ) -> AnyPublisher<RMModels.Api.Comment.CommentResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Comment.createCommentLike.endpoint, parameters: parameters)
    }
    
    func asyncCreateCommentReport(
        parameters: RMModels.Api.Comment.CreateCommentReport
    ) -> AnyPublisher<RMModels.Api.Comment.CommentReportResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Comment.createCommentReport.endpoint, parameters: parameters)
    }
    
    func asyncResolveCommentReport(
        parameters: RMModels.Api.Comment.ResolveCommentReport
    ) -> AnyPublisher<RMModels.Api.Comment.ResolveCommentReport, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Comment.resolveCommentReport.endpoint, parameters: parameters)
    }
    
    func asyncListCommentReports(
        parameters: RMModels.Api.Comment.ListCommentReports
    ) -> AnyPublisher<RMModels.Api.Comment.ListCommentReportsResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Comment.listCommentReports.endpoint, parameters: parameters)
    }
}
