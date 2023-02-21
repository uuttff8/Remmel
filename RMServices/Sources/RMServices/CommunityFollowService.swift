//
//  CommunityFollowService.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 17.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine
import RMModels
import RMFoundation
import RMNetworking

public protocol CommunityFollowServiceProtocol {
    func followUi(
        to community: RMModels.Views.CommunityView
    ) -> AnyPublisher<RMModels.Views.CommunityView, Never>
    func follow(
        to community: RMModels.Views.CommunityView
    ) -> AnyPublisher<RMModels.Views.CommunityView, LemmyGenericError>
}

public class CommunityFollowService: CommunityFollowServiceProtocol {
    
    private let userAccountService: UserAccountServiceProtocol
    
    private var cancellable = Set<AnyCancellable>()
    
    public init(
        userAccountService: UserAccountServiceProtocol
    ) {
        self.userAccountService = userAccountService
    }
    
    public func followUi(
        to community: RMModels.Views.CommunityView
    ) -> AnyPublisher<RMModels.Views.CommunityView, Never> {
        
        Future<RMModels.Views.CommunityView, Never> { promise in
            self.follow(to: community)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    Logger.logCombineCompletion(completion)
                } receiveValue: { respCommunity in
                    promise(.success(respCommunity))
                }.store(in: &self.cancellable)
        }.eraseToAnyPublisher()
    }
    
    public func follow(
        to community: RMModels.Views.CommunityView
    ) -> AnyPublisher<RMModels.Views.CommunityView, LemmyGenericError> {
        
        guard let jwtToken = self.userAccountService.jwtToken
        else {
            return Fail(error: LemmyGenericError.string("failed to fetch jwt token"))
                .eraseToAnyPublisher()
        }
        
        let isSubscribed: Bool = community.subscribed == .subscribed
        
        let params = RMModels.Api.Community.FollowCommunity(communityId: community.id,
                                                            follow: !isSubscribed,
                                                            auth: jwtToken)
        
        return ApiManager.requests.asyncFollowCommunity(parameters: params)
            .map({ $0.communityView })
            .eraseToAnyPublisher()
        
    }
}
