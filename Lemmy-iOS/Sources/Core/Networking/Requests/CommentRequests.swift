//
//  CommentRequests.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation
import Combine

extension RequestsManager {
    func asyncGetComments(
        parameters: LMModels.Api.Comment.GetComments
    ) -> AnyPublisher<LMModels.Api.Comment.GetCommentsResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Comment.getComments.endpoint, parameters: parameters)
    }
    
    func asyncCreateComment(
        parameters: LMModels.Api.Comment.CreateComment
    ) -> AnyPublisher<LMModels.Api.Comment.CommentResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Comment.createComment.endpoint, parameters: parameters)
    }
    
    func asyncEditComment(
        parameters: LMModels.Api.Comment.EditComment
    ) -> AnyPublisher<LMModels.Api.Comment.CommentResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Comment.editComment.endpoint, parameters: parameters)
    }
    
    func asyncDeleteComment(
        parameters: LMModels.Api.Comment.DeleteComment
    ) -> AnyPublisher<LMModels.Api.Comment.CommentResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Comment.deleteComment.endpoint, parameters: parameters)
    }
    
    func asyncRemoveComment(
        parameters: LMModels.Api.Comment.RemoveComment
    ) -> AnyPublisher<LMModels.Api.Comment.CommentResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Comment.removeComment.endpoint, parameters: parameters)
    }
    
    func asyncMarkCommentAsReadRequest(
        parameters: LMModels.Api.Comment.MarkCommentAsRead
    ) -> AnyPublisher<LMModels.Api.Comment.CommentResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Comment.markCommentAsRead.endpoint, parameters: parameters)
    }
    
    func asyncSaveComment(
        parameters: LMModels.Api.Comment.SaveComment
    ) -> AnyPublisher<LMModels.Api.Comment.CommentResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Comment.saveComment.endpoint, parameters: parameters)
    }
    
    func asyncCreateCommentLike(
        parameters: LMModels.Api.Comment.CreateCommentLike
    ) -> AnyPublisher<LMModels.Api.Comment.CommentResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Comment.createCommentLike.endpoint, parameters: parameters)
    }
    
    func asyncCreateCommentReport(
        parameters: LMModels.Api.Comment.CreateCommentReport
    ) -> AnyPublisher<LMModels.Api.Comment.CreateCommentReportResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Comment.createCommentReport.endpoint, parameters: parameters)
    }
    
    func asyncResolveCommentReport(
        parameters: LMModels.Api.Comment.ResolveCommentReport
    ) -> AnyPublisher<LMModels.Api.Comment.ResolveCommentReport, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Comment.resolveCommentReport.endpoint, parameters: parameters)
    }
    
    func asyncListCommentReports(
        parameters: LMModels.Api.Comment.ListCommentReports
    ) -> AnyPublisher<LMModels.Api.Comment.ListCommentReportsResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Comment.listCommentReports.endpoint, parameters: parameters)
    }
}
