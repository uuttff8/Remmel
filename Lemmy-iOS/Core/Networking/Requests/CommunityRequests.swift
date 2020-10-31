//
//  CommunityRequests.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/14/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

private protocol LemmyCommunityRequestManagerProtocol {
    func listCommunities<Req: Codable, Res: Codable>(
        parameters: Req,
        completion: @escaping (Result<Res, LemmyGenericError>) -> Void
    )
    func createCommunity(
        parameters: LemmyApiStructs.Community.CreateCommunityRequest,
        completion: @escaping (Result<LemmyApiStructs.Community.CreateCommunityResponse, LemmyGenericError>) -> Void
    )
}

extension RequestsManager: LemmyCommunityRequestManagerProtocol {
    func listCommunities<Req, Res>(
        parameters: Req,
        completion: @escaping (Result<Res, LemmyGenericError>) -> Void
    ) where Req: Codable, Res: Codable {

        return requestDecodable(
            path: LemmyEndpoint.Community.listCommunities.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion)
    }

    func createCommunity(
        parameters: LemmyApiStructs.Community.CreateCommunityRequest,
        completion: @escaping (Result<LemmyApiStructs.Community.CreateCommunityResponse, LemmyGenericError>) -> Void
    ) {

        return requestDecodable(path: LemmyEndpoint.Community.createCommunity.endpoint,
                                parameters: parameters,
                                parsingFromRootKey: "data",
                                completion: completion)
    }

}
