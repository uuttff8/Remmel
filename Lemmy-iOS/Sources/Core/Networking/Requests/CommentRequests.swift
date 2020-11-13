//
//  CommentRequests.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

private protocol CommentRequestManagerProtocol {
    func getComments(
        parameters: LemmyModel.Comment.GetCommentsRequest,
        completion: @escaping ((Result<LemmyModel.Comment.GetCommentsResponse, LemmyGenericError>) -> Void)
    )
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
}
