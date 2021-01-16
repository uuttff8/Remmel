//
//  UserRequests.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/14/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation
import Combine

extension RequestsManager {
        
    func asyncGetUserDetails(
        parameters: LMModels.Api.User.GetUserDetails
    ) -> AnyPublisher<LMModels.Api.User.GetUserDetailsResponse, LemmyGenericError> {
        
        asyncRequestDecodable(path: WSEndpoint.User.getUserDetails.endpoint,
                              parameters: parameters)
    }
    
    func asyncSaveUserSettings(
        parameters: LMModels.Api.User.SaveUserSettings
    ) -> AnyPublisher<LMModels.Api.User.LoginResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.User.saveUserSettings.endpoint, parameters: parameters)
    }
    
    func asyncGetReplies(
        parameters: LMModels.Api.User.GetReplies
    ) -> AnyPublisher<LMModels.Api.User.GetRepliesResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.User.getReplies.endpoint, parameters: parameters)
    }
    
    func asyncGetUserMentions(
        parameters: LMModels.Api.User.GetUserMentions
    ) -> AnyPublisher<LMModels.Api.User.GetUserMentionsResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.User.getUserMentions.endpoint, parameters: parameters)
    }
    
    func asyncMarkUserMentionAsRead<Req: Codable, Res: Codable>(
        parameters: Req
    ) -> AnyPublisher<Res, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.User.markUserMentionAsRead.endpoint, parameters: parameters)
    }
    
    func asyncCreatePrivateMessage(
        parameters: LMModels.Api.User.CreatePrivateMessage
    ) -> AnyPublisher<LMModels.Api.User.PrivateMessageResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.User.createPrivateMessage.endpoint, parameters: parameters)
    }
    
    func asyncGetPrivateMessages(
        parameters: LMModels.Api.User.GetPrivateMessages
    ) -> AnyPublisher<LMModels.Api.User.PrivateMessagesResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.User.getPrivateMessages.endpoint, parameters: parameters)
    }
}
