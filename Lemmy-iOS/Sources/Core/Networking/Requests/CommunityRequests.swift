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
    func asyncGetCommunity(
        parameters: LemmyModel.Community.GetCommunityRequest
    ) -> AnyPublisher<LemmyModel.Community.GetCommunityResponse, LemmyGenericError>
    
    func asyncFollowCommunity(
        parameters: LemmyModel.Community.FollowCommunityRequest
    ) -> AnyPublisher<LemmyModel.Community.FollowCommunityResponse, LemmyGenericError>
    
    func asyncListCommunities(
        parameters: LemmyModel.Community.ListCommunitiesRequest
    ) -> AnyPublisher<LemmyModel.Community.ListCommunitiesResponse, LemmyGenericError>
    
    func asyncCreateCommunity(
        parameters: LemmyModel.Community.CreateCommunityRequest
    ) -> AnyPublisher<LemmyModel.Community.CreateCommunityResponse, LemmyGenericError>
}

extension RequestsManager: LemmyCommunityRequestManagerProtocol {    
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
    
    func asyncListCommunities(
        parameters: LemmyModel.Community.ListCommunitiesRequest
    ) -> AnyPublisher<LemmyModel.Community.ListCommunitiesResponse, LemmyGenericError> {
        
        asyncRequestDecodable(path: WSEndpoint.Community.listCommunities.endpoint,
                              parameters: parameters)
    }
    
    func asyncCreateCommunity(
        parameters: LemmyModel.Community.CreateCommunityRequest
    ) -> AnyPublisher<LemmyModel.Community.CreateCommunityResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Community.createCommunity.endpoint,
                              parameters: parameters)
    }
}
