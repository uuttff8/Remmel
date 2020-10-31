//
//  CommentRequests.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

private protocol CommentRequestManagerProtocol {
    func getComments<Req: Codable, Res: Codable>(parameters: Req, completion: @escaping ((Result<Res, LemmyGenericError>) -> Void))
}

extension RequestsManager: CommentRequestManagerProtocol {
    func getComments<Req: Codable, Res: Codable>(
        parameters: Req,
        completion: @escaping ((Result<Res, LemmyGenericError>) -> Void)
    ) {
        return requestDecodable(
            path: LemmyEndpoint.Comment.getComments.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion
        )
    }
}
