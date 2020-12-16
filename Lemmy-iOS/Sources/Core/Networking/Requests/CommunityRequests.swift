//
//  CommunityRequests.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/14/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation
import Combine

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
    
    func asyncGetCommunity(
        parameters: LemmyModel.Community.GetCommunityRequest
    ) -> AnyPublisher<LemmyModel.Community.GetCommunityResponse, LemmyGenericError>
    
    func asyncFollowCommunity(
        parameters: LemmyModel.Community.FollowCommunityRequest
    ) -> AnyPublisher<LemmyModel.Community.FollowCommunityResponse, LemmyGenericError>
    
    func asyncListCommunity(
        parameters: LemmyModel.Community.ListCommunitiesRequest
    ) -> AnyPublisher<LemmyModel.Community.ListCommunitiesResponse, LemmyGenericError>
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
    
    func asyncGetCommunity(
        parameters: LemmyModel.Community.GetCommunityRequest
    ) -> AnyPublisher<LemmyModel.Community.GetCommunityResponse, LemmyGenericError> {
        
        asyncRequestDecodable(path: WSEndpoint.Community.getCommunity.endpoint,
                              parameters: parameters)
        
    }
    
    func asyncFollowCommunity(
        parameters: LemmyModel.Community.FollowCommunityRequest
    ) -> AnyPublisher<LemmyModel.Community.FollowCommunityResponse, LemmyGenericError> {
        
        asyncRequestDecodable(path: WSEndpoint.Community.followCommunity.endpoint,
                              parameters: parameters)
        
    }
    
    func asyncListCommunity(
        parameters: LemmyModel.Community.ListCommunitiesRequest
    ) -> AnyPublisher<LemmyModel.Community.ListCommunitiesResponse, LemmyGenericError> {
        
        asyncRequestDecodable(path: WSEndpoint.Community.listCommunities.endpoint,
                              parameters: parameters)
    }
    
}
