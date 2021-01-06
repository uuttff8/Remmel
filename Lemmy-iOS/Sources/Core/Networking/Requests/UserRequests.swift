//
//  UserRequests.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/14/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation
import Combine

private protocol UserRequestManagerProtocol {
    func asyncGetUserDetails(
        parameters: LemmyModel.User.GetUserDetailsRequest
    ) -> AnyPublisher<LemmyModel.User.GetUserDetailsResponse, LemmyGenericError>
    
    func asyncSaveUserSettings(
        parameters: LemmyModel.User.SaveUserSettingsRequest
    ) -> AnyPublisher<LemmyModel.User.SaveUserSettingsResponse, LemmyGenericError>
    
    func asyncGetReplies(
        parameters: LemmyModel.User.GetRepliesRequest
    ) -> AnyPublisher<LemmyModel.User.GetRepliesResponse, LemmyGenericError>
        
    func asyncGetUserMentions(
        parameters: LemmyModel.User.GetUserMentionsRequest
    ) -> AnyPublisher<LemmyModel.User.GetUserMentionsResponse, LemmyGenericError>
    
    func asyncMarkUserMentionAsRead<Req: Codable, Res: Codable>(
        parameters: Req
    ) -> AnyPublisher<Res, LemmyGenericError>
    
    func asyncCreatePrivateMessage(
        parameters: LemmyModel.User.CreatePrivateMessageRequest
    ) -> AnyPublisher<LemmyModel.User.CreatePrivateMessageResponse, LemmyGenericError>
}

extension RequestsManager: UserRequestManagerProtocol {
        
    func asyncGetUserDetails(
        parameters: LemmyModel.User.GetUserDetailsRequest
    ) -> AnyPublisher<LemmyModel.User.GetUserDetailsResponse, LemmyGenericError> {
        
        asyncRequestDecodable(path: WSEndpoint.User.getUserDetails.endpoint,
                              parameters: parameters)
    }
    
    func asyncSaveUserSettings(
        parameters: LemmyModel.User.SaveUserSettingsRequest
    ) -> AnyPublisher<LemmyModel.User.SaveUserSettingsResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.User.saveUserSettings.endpoint, parameters: parameters)
    }
    
    func asyncGetReplies(
        parameters: LemmyModel.User.GetRepliesRequest
    ) -> AnyPublisher<LemmyModel.User.GetRepliesResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.User.getReplies.endpoint, parameters: parameters)
    }
    
    func asyncGetUserMentions(
        parameters: LemmyModel.User.GetUserMentionsRequest
    ) -> AnyPublisher<LemmyModel.User.GetUserMentionsResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.User.getUserMentions.endpoint, parameters: parameters)
    }
    
    func asyncMarkUserMentionAsRead<Req: Codable, Res: Codable>(
        parameters: Req
    ) -> AnyPublisher<Res, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.User.markUserMentionAsRead.endpoint, parameters: parameters)
    }
    
    func asyncCreatePrivateMessage(
        parameters: LemmyModel.User.CreatePrivateMessageRequest
    ) -> AnyPublisher<LemmyModel.User.CreatePrivateMessageResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.User.createPrivateMessage.endpoint, parameters: parameters)
    }
}
