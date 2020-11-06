//
//  CommunityRequests.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/14/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

private protocol LemmyCommunityRequestManagerProtocol {
    func listCommunities(
        parameters: LemmyModel.Community.ListCommunitiesRequest,
        completion: @escaping (Result<LemmyModel.Community.ListCommunitiesResponse, LemmyGenericError>) -> Void
    )
    
    func createCommunity(
        parameters: LemmyModel.Community.CreateCommunityRequest,
        completion: @escaping (Result<LemmyModel.Community.CreateCommunityResponse, LemmyGenericError>) -> Void
    )
    
    func getCommunity(
        parameters: LemmyModel.Community.GetCommunityRequest,
        completion: @escaping (Result<LemmyModel.Community.GetCommunityResponse, LemmyGenericError>) -> Void
    )
}

extension RequestsManager: LemmyCommunityRequestManagerProtocol {
    func listCommunities<Req, Res>(
        parameters: Req,
        completion: @escaping (Result<Res, LemmyGenericError>) -> Void
    ) where Req: Codable, Res: Codable {
        
        return requestDecodable(
            path: WSEndpoint.Community.listCommunities.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion)
    }
    
    func createCommunity(
        parameters: LemmyModel.Community.CreateCommunityRequest,
        completion: @escaping (Result<LemmyModel.Community.CreateCommunityResponse, LemmyGenericError>) -> Void
    ) {
        
        return requestDecodable(path: WSEndpoint.Community.createCommunity.endpoint,
                                parameters: parameters,
                                parsingFromRootKey: "data",
                                completion: completion)
    }
    
    func getCommunity(
        parameters: LemmyModel.Community.GetCommunityRequest,
        completion: @escaping (Result<LemmyModel.Community.GetCommunityResponse, LemmyGenericError>) -> Void
    ) {
        
        return requestDecodable(path: WSEndpoint.Community.getCommunity.endpoint,
                                parameters: parameters,
                                parsingFromRootKey: "data",
                                completion: completion)
    }
    
}
