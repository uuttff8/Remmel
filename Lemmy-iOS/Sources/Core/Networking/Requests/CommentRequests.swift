//
//  CommentRequests.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation
import Combine

private protocol CommentRequestManagerProtocol {
    func getComments(
        parameters: LemmyModel.Comment.GetCommentsRequest,
        completion: @escaping ((Result<LemmyModel.Comment.GetCommentsResponse, LemmyGenericError>) -> Void)
    )
    
    func asyncCreateComment(
        parameters: LemmyModel.Comment.CreateCommentRequest
    ) -> AnyPublisher<LemmyModel.Comment.CreateCommentResponse, LemmyGenericError>
    
    func asyncEditComment(
        parameters: LemmyModel.Comment.EditCommentRequest
    ) -> AnyPublisher<LemmyModel.Comment.EditCommentResponse, LemmyGenericError>
    
    func asyncEditComment(
        parameters: LemmyModel.Comment.DeleteCommentRequest
    ) -> AnyPublisher<LemmyModel.Comment.DeleteCommentResponse, LemmyGenericError>
    
    func asyncRemoveComment(
        parameters: LemmyModel.Comment.RemoveCommentRequest
    ) -> AnyPublisher<LemmyModel.Comment.RemoveCommentResponse, LemmyGenericError>
    
    func asyncMarkCommentAsReadRequest(
        parameters: LemmyModel.Comment.MarkCommentAsReadRequest
    ) -> AnyPublisher<LemmyModel.Comment.MarkCommentAsReadResponse, LemmyGenericError>
    
    func asyncSaveComment(
        parameters: LemmyModel.Comment.SaveCommentRequest
    ) -> AnyPublisher<LemmyModel.Comment.SaveCommentResponse, LemmyGenericError>
    
    func asyncCreateCommentLike(
        parameters: LemmyModel.Comment.CreateCommentLikeRequest
    ) -> AnyPublisher<LemmyModel.Comment.CreateCommentLikeResponse, LemmyGenericError>
    
    func asyncCreateCommentReport(
        parameters: LemmyModel.Comment.CreateCommentReportRequest
    ) -> AnyPublisher<LemmyModel.Comment.CreateCommentReportResponse, LemmyGenericError>
    
    func asyncResolveCommentReport(
        parameters: LemmyModel.Comment.ResolveCommentReportRequest
    ) -> AnyPublisher<LemmyModel.Comment.ResolveCommentReportResponse, LemmyGenericError>
    
    func asyncListCommentReports(
        parameters: LemmyModel.Comment.ListCommentReportsRequest
    ) -> AnyPublisher<LemmyModel.Comment.ListCommentReportsResponse, LemmyGenericError>
}

extension RequestsManager: CommentRequestManagerProtocol {
    func getComments(
        parameters: LemmyModel.Comment.GetCommentsRequest,
        completion: @escaping ((Result<LemmyModel.Comment.GetCommentsResponse, LemmyGenericError>) -> Void)
    ) {
        return requestDecodable(
            path: WSEndpoint.Comment.getComments.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion
        )
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
        parameters: LemmyModel.Comment.CreateCommentLikeRequest
    ) -> AnyPublisher<LemmyModel.Comment.CreateCommentLikeResponse, LemmyGenericError> {
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
