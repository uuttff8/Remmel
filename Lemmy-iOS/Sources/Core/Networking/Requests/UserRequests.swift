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
        parameters: LMModels.Api.Person.GetPersonDetails
    ) -> AnyPublisher<LMModels.Api.Person.GetPersonDetailsResponse, LemmyGenericError> {
        
        asyncRequestDecodable(path: WSEndpoint.User.getPersonDetails.endpoint,
                              parameters: parameters)
    }
    
    func asyncSaveUserSettings(
        parameters: LMModels.Api.Person.SaveUserSettings
    ) -> AnyPublisher<LMModels.Api.Person.LoginResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.User.saveUserSettings.endpoint, parameters: parameters)
    }
    
    func asyncChangePassword(
        parameters: LMModels.Api.Person.SaveUserSettings
    ) -> 
    
    func asyncGetReplies(
        parameters: LMModels.Api.Person.GetReplies
    ) -> AnyPublisher<LMModels.Api.Person.GetRepliesResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.User.getReplies.endpoint, parameters: parameters)
    }
    
    func asyncGetPersonMentions(
        parameters: LMModels.Api.Person.GetPersonMentions
    ) -> AnyPublisher<LMModels.Api.Person.GetPersonMentionsResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.User.getPersonMentions.endpoint, parameters: parameters)
    }
    
    func asyncMarkPersonMentionAsRead<Req: Codable, Res: Codable>(
        parameters: Req
    ) -> AnyPublisher<Res, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.User.markPersonMentionAsRead.endpoint, parameters: parameters)
    }
    
    func asyncCreatePrivateMessage(
        parameters: LMModels.Api.Person.CreatePrivateMessage
    ) -> AnyPublisher<LMModels.Api.Person.PrivateMessageResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.User.createPrivateMessage.endpoint, parameters: parameters)
    }
    
    func asyncGetPrivateMessages(
        parameters: LMModels.Api.Person.GetPrivateMessages
    ) -> AnyPublisher<LMModels.Api.Person.PrivateMessagesResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.User.getPrivateMessages.endpoint, parameters: parameters)
    }
}
