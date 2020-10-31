//
//  PostRequests.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

private protocol LemmyPostRequestManagerProtocol {
    func getPosts<Req: Codable, Res: Codable>(parameters: Req, completion: @escaping ((Result<Res, LemmyGenericError>) -> Void))
    func getPost<Req: Codable, Res: Codable>(parameters: Req, completion: @escaping ((Result<Res, LemmyGenericError>) -> Void))
    func createPost<Res: Codable>(
        parameters: LemmyApiStructs.Post.CreatePostRequest,
        completion: @escaping ((Result<Res, LemmyGenericError>) -> Void)
    )
}

extension RequestsManager: LemmyPostRequestManagerProtocol {
    func getPosts<Req, Res>(
        parameters: Req,
        completion: @escaping (Result<Res, LemmyGenericError>) -> Void
    ) where Req: Codable, Res: Codable {

        return requestDecodable(
            path: LemmyEndpoint.Post.getPosts.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion
        )
    }

    func getPost<Req: Codable, Res: Codable>(
        parameters: Req,
        completion: @escaping ((Result<Res, LemmyGenericError>) -> Void)
    ) {
        return requestDecodable(
            path: LemmyEndpoint.Post.getPost.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion
        )
    }

    func createPost<Res: Codable>(
        parameters: LemmyApiStructs.Post.CreatePostRequest,
        completion: @escaping ((Result<Res, LemmyGenericError>) -> Void)
    ) {
        return requestDecodable(
            path: LemmyEndpoint.Post.createPost.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion
        )
    }
}
