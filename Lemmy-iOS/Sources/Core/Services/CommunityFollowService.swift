//
//  CommunityFollowService.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 17.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

protocol CommunityFollowServiceProtocol {
    func followUi(
        followButton: FollowButton,
        to community: LemmyModel.CommunityView
    ) -> AnyPublisher<LemmyModel.CommunityView, Never>
    func follow(to community: LemmyModel.CommunityView) -> AnyPublisher<LemmyModel.CommunityView, LemmyGenericError>
}

class CommunityFollowService: CommunityFollowServiceProtocol {
    
    private let userAccountService: UserAccountSerivceProtocol
    
    private var cancellable = Set<AnyCancellable>()
    
    init(
        userAccountService: UserAccountSerivceProtocol
    ) {
        self.userAccountService = userAccountService
    }
    
    func followUi(
        followButton: FollowButton,
        to community: LemmyModel.CommunityView
    ) -> AnyPublisher<LemmyModel.CommunityView, Never> {
        
        Future<LemmyModel.CommunityView, Never> { promise in
            
            followButton.followState = .pending
            
            self.follow(to: community)
                .receive(on: DispatchQueue.main)
                .sink { (completion) in
                    Logger.logCombineCompletion(completion)
                } receiveValue: { (respCommunity) in
                    followButton.bind(isSubcribed: respCommunity.subscribed)
                    
                    promise(.success(respCommunity))
                    
                }.store(in: &self.cancellable)
            
        }.eraseToAnyPublisher()
    }
    
    func follow(to community: LemmyModel.CommunityView) -> AnyPublisher<LemmyModel.CommunityView, LemmyGenericError> {
        
        guard let jwtToken = self.userAccountService.jwtToken
        else {
            return Fail(error: LemmyGenericError.string("failed to fetch jwt token"))
                .eraseToAnyPublisher()
        }
        
        let isSubscribed: Bool = community.subscribed ?? false
        
        let params = LemmyModel.Community.FollowCommunityRequest(communityId: community.id,
                                                                 follow: !isSubscribed,
                                                                 auth: jwtToken)
        
        return ApiManager.requests.asyncFollowCommunity(parameters: params)
            .map({ $0.community })
            .eraseToAnyPublisher()
        
    }
}
