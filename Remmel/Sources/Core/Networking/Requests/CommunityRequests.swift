//
//  CommunityRequests.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/14/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation
import Combine

extension RequestsManager {
    func asyncGetCommunity(
        parameters: LMModels.Api.Community.GetCommunity
    ) -> AnyPublisher<LMModels.Api.Community.GetCommunityResponse, LemmyGenericError> {
        
        asyncRequestDecodable(path: WSEndpoint.Community.getCommunity.endpoint,
                              parameters: parameters)
        
    }
    
    func asyncFollowCommunity(
        parameters: LMModels.Api.Community.FollowCommunity
    ) -> AnyPublisher<LMModels.Api.Community.CommunityResponse, LemmyGenericError> {
        
        asyncRequestDecodable(path: WSEndpoint.Community.followCommunity.endpoint,
                              parameters: parameters)
        
    }
    
    func asyncListCommunities(
        parameters: LMModels.Api.Community.ListCommunities
    ) -> AnyPublisher<LMModels.Api.Community.ListCommunitiesResponse, LemmyGenericError> {
        
        asyncRequestDecodable(path: WSEndpoint.Community.listCommunities.endpoint,
                              parameters: parameters)
    }
    
    func asyncCreateCommunity(
        parameters: LMModels.Api.Community.CreateCommunity
    ) -> AnyPublisher<LMModels.Api.Community.CommunityResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Community.createCommunity.endpoint,
                              parameters: parameters)
    }
}
