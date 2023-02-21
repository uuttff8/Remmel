//
//  UserRequests.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/14/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation
import Combine
import RMFoundation
import RMModels

public extension RequestsManager {
        
    func asyncGetUserDetails(
        parameters: RMModels.Api.Person.GetPersonDetails
    ) -> AnyPublisher<RMModels.Api.Person.GetPersonDetailsResponse, LemmyGenericError> {
        
        asyncRequestDecodable(path: WSEndpoint.User.getPersonDetails.endpoint,
                              parameters: parameters)
    }
    
    func asyncSaveUserSettings(
        parameters: RMModels.Api.Person.SaveUserSettings
    ) -> AnyPublisher<RMModels.Api.Person.LoginResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.User.saveUserSettings.endpoint, parameters: parameters)
    }
    
    func asyncChangePassword(
        parameters: RMModels.Api.Person.ChangePassword
    ) -> AnyPublisher<RMModels.Api.Person.LoginResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.User.changePassword.endpoint, parameters: parameters)
    }
    
    func asyncGetReplies(
        parameters: RMModels.Api.Person.GetReplies
    ) -> AnyPublisher<RMModels.Api.Person.GetRepliesResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.User.getReplies.endpoint, parameters: parameters)
    }
    
    func asyncGetPersonMentions(
        parameters: RMModels.Api.Person.GetPersonMentions
    ) -> AnyPublisher<RMModels.Api.Person.GetPersonMentionsResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.User.getPersonMentions.endpoint, parameters: parameters)
    }
    
    func asyncMarkPersonMentionAsRead<Req: Codable, Res: Codable>(
        parameters: Req
    ) -> AnyPublisher<Res, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.User.markPersonMentionAsRead.endpoint, parameters: parameters)
    }
    
    func asyncCreatePrivateMessage(
        parameters: RMModels.Api.Person.CreatePrivateMessage
    ) -> AnyPublisher<RMModels.Api.Person.PrivateMessageResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.User.createPrivateMessage.endpoint, parameters: parameters)
    }
    
    func asyncGetPrivateMessages(
        parameters: RMModels.Api.Person.GetPrivateMessages
    ) -> AnyPublisher<RMModels.Api.Person.PrivateMessagesResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.User.getPrivateMessages.endpoint, parameters: parameters)
    }
}
