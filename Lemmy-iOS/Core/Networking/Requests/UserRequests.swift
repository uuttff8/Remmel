//
//  UserRequests.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/14/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

private protocol UserRequestManagerProtocol {
    func getUserDetails(
        parameters: LemmyModel.User.GetUserDetailsRequest,
        completion: @escaping (Result<LemmyModel.User.GetUserDetailsResponse, LemmyGenericError>) -> Void
    )
    
    func saveUserSettings(
        parameters: LemmyModel.User.SaveUserSettingsRequest,
        completion: @escaping (Result<LemmyModel.User.SaveUserSettingsResponse, LemmyGenericError>) -> Void
    )
    
    func getReplies(
        parameters: LemmyModel.User.GetRepliesRequest,
        completion: @escaping (Result<LemmyModel.User.GetRepliesResponse, LemmyGenericError>) -> Void
    )
    
    func getUserMentions(
        parameters: LemmyModel.User.GetUserMentionsRequest,
        completion: @escaping (Result<LemmyModel.User.GetUserMentionsResponse, LemmyGenericError>) -> Void
    )
    
    func markUserMentionAsRead<Req: Codable, Res: Codable>(
        parameters: Req,
        completion: @escaping (Result<Res, LemmyGenericError>) -> Void
    )
}

extension RequestsManager: UserRequestManagerProtocol {
    func getUserDetails(
        parameters: LemmyModel.User.GetUserDetailsRequest,
        completion: @escaping (Result<LemmyModel.User.GetUserDetailsResponse, LemmyGenericError>) -> Void
    ) {

        return requestDecodable(
            path: WSEndpoint.User.getUserDetails.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion
        )
    }

    func saveUserSettings(
        parameters: LemmyModel.User.SaveUserSettingsRequest,
        completion: @escaping (Result<LemmyModel.User.SaveUserSettingsResponse, LemmyGenericError>) -> Void
    ) {

        return requestDecodable(
            path: WSEndpoint.User.saveUserSettings.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion
        )
    }

    func getReplies(
        parameters: LemmyModel.User.GetRepliesRequest,
        completion: @escaping (Result<LemmyModel.User.GetRepliesResponse, LemmyGenericError>) -> Void
    ) {

        return requestDecodable(
            path: WSEndpoint.User.getReplies.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion
        )
    }

    func getUserMentions(
        parameters: LemmyModel.User.GetUserMentionsRequest,
        completion: @escaping (Result<LemmyModel.User.GetUserMentionsResponse, LemmyGenericError>) -> Void
    ) {

        return requestDecodable(
            path: WSEndpoint.User.getUserMentions.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion
        )
    }

    func markUserMentionAsRead<Req, Res>(
        parameters: Req,
        completion: @escaping (Result<Res, LemmyGenericError>) -> Void
    ) where Req: Codable, Res: Codable {

        return requestDecodable(
            path: WSEndpoint.User.markUserMentionAsRead.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion
        )
    }
}
