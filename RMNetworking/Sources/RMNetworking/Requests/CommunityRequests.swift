//
//  CommunityRequests.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/14/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation
import Combine
import RMFoundation
import RMModels

public extension RequestsManager {
    func asyncGetCommunity(
        parameters: RMModels.Api.Community.GetCommunity
    ) -> AnyPublisher<RMModels.Api.Community.GetCommunityResponse, LemmyGenericError> {
        
        asyncRequestDecodable(path: WSEndpoint.Community.getCommunity.endpoint,
                              parameters: parameters)
        
    }
    
    func asyncFollowCommunity(
        parameters: RMModels.Api.Community.FollowCommunity
    ) -> AnyPublisher<RMModels.Api.Community.CommunityResponse, LemmyGenericError> {
        
        asyncRequestDecodable(path: WSEndpoint.Community.followCommunity.endpoint,
                              parameters: parameters)
        
    }
    
    func asyncListCommunities(
        parameters: RMModels.Api.Community.ListCommunities
    ) -> AnyPublisher<RMModels.Api.Community.ListCommunitiesResponse, LemmyGenericError> {
        
        asyncRequestDecodable(path: WSEndpoint.Community.listCommunities.endpoint,
                              parameters: parameters)
    }
    
    func asyncCreateCommunity(
        parameters: RMModels.Api.Community.CreateCommunity
    ) -> AnyPublisher<RMModels.Api.Community.CommunityResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Community.createCommunity.endpoint,
                              parameters: parameters)
    }
}
