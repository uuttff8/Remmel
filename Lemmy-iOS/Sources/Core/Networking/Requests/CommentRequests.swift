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
        parameters: LemmyModel.Comment.GetCommentsRequest
    ) -> AnyPublisher<LemmyModel.Comment.GetCommentsResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Comment.getComments.endpoint, parameters: parameters)
    }
    
    func asyncCreateComment(
        parameters: LemmyModel.Comment.CreateCommentRequest
    ) -> AnyPublisher<LemmyModel.Comment.CreateCommentResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Comment.createComment.endpoint, parameters: parameters)
    }
    
    func asyncEditComment(
        parameters: LemmyModel.Comment.EditCommentRequest
    ) -> AnyPublisher<LemmyModel.Comment.EditCommentResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Comment.editComment.endpoint, parameters: parameters)
    }
    
    func asyncEditComment(
        parameters: LemmyModel.Comment.DeleteCommentRequest
    ) -> AnyPublisher<LemmyModel.Comment.DeleteCommentResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Comment.deleteComment.endpoint, parameters: parameters)
    }
    
    func asyncRemoveComment(
        parameters: LemmyModel.Comment.RemoveCommentRequest
    ) -> AnyPublisher<LemmyModel.Comment.RemoveCommentResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Comment.removeComment.endpoint, parameters: parameters)
    }
    
    func asyncMarkCommentAsReadRequest(
        parameters: LemmyModel.Comment.MarkCommentAsReadRequest
    ) -> AnyPublisher<LemmyModel.Comment.MarkCommentAsReadResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Comment.markCommentAsRead.endpoint, parameters: parameters)
    }
    
    func asyncSaveComment(
        parameters: LemmyModel.Comment.SaveCommentRequest
    ) -> AnyPublisher<LemmyModel.Comment.SaveCommentResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Comment.saveComment.endpoint, parameters: parameters)
    }
    
    func asyncCreateCommentLike(
        parameters: LMModels.Api.Comment.CreateCommentLike
    ) -> AnyPublisher<LMModels.Api.Comment.CommentResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Comment.createCommentLike.endpoint, parameters: parameters)
    }
    
    func asyncCreateCommentReport(
        parameters: LemmyModel.Comment.CreateCommentReportRequest
    ) -> AnyPublisher<LemmyModel.Comment.CreateCommentReportResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Comment.createCommentReport.endpoint, parameters: parameters)
    }
    
    func asyncResolveCommentReport(
        parameters: LemmyModel.Comment.ResolveCommentReportRequest
    ) -> AnyPublisher<LemmyModel.Comment.ResolveCommentReportResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Comment.resolveCommentReport.endpoint, parameters: parameters)
    }
    
    func asyncListCommentReports(
        parameters: LemmyModel.Comment.ListCommentReportsRequest
    ) -> AnyPublisher<LemmyModel.Comment.ListCommentReportsResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Comment.listCommentReports.endpoint, parameters: parameters)
    }
}
