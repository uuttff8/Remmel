//
//  CommunityRequests.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/14/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

private protocol LemmyCommunityRequestManagerProtocol {
    func listCommunities<Req: Codable, Res: Codable>(parameters: Req, completion: @escaping (Result<Res, Error>) -> Void)
}

extension RequestsManager: LemmyCommunityRequestManagerProtocol {
    func listCommunities<Req, Res>(
        parameters: Req,
        completion: @escaping (Result<Res, Error>) -> Void
    ) where Req : Codable, Res : Codable {
        
        return requestDecodable(
            path: LemmyEndpoint.Community.listCommunities.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion)
    }
}
