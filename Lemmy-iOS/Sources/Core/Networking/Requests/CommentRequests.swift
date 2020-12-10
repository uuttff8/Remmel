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

}
