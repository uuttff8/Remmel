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
        parameters: LemmyApiStructs.User.GetUserDetailsRequest,
        completion: @escaping (Result<LemmyApiStructs.User.GetUserDetailsResponse, LemmyGenericError>) -> Void
    )
    
    func saveUserSettings(
        parameters: LemmyApiStructs.User.SaveUserSettingsRequest,
        completion: @escaping (Result<LemmyApiStructs.User.SaveUserSettingsResponse, LemmyGenericError>) -> Void
    )
    
    func getReplies(
        parameters: LemmyApiStructs.User.GetRepliesRequest,
        completion: @escaping (Result<LemmyApiStructs.User.GetRepliesResponse, LemmyGenericError>) -> Void
    )
    
    func getUserMentions(
        parameters: LemmyApiStructs.User.GetUserMentionsRequest,
        completion: @escaping (Result<LemmyApiStructs.User.GetUserMentionsResponse, LemmyGenericError>) -> Void
    )
    
    func markUserMentionAsRead<Req: Codable, Res: Codable>(
        parameters: Req,
        completion: @escaping (Result<Res, LemmyGenericError>) -> Void
    )
}

extension RequestsManager: UserRequestManagerProtocol {
    func getUserDetails(
        parameters: LemmyApiStructs.User.GetUserDetailsRequest,
        completion: @escaping (Result<LemmyApiStructs.User.GetUserDetailsResponse, LemmyGenericError>) -> Void
    ) {

        return requestDecodable(
            path: LemmyEndpoint.User.getUserDetails.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion
        )
    }

    func saveUserSettings(
        parameters: LemmyApiStructs.User.SaveUserSettingsRequest,
        completion: @escaping (Result<LemmyApiStructs.User.SaveUserSettingsResponse, LemmyGenericError>) -> Void
    ) {

        return requestDecodable(
            path: LemmyEndpoint.User.saveUserSettings.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion
        )
    }

    func getReplies(
        parameters: LemmyApiStructs.User.GetRepliesRequest,
        completion: @escaping (Result<LemmyApiStructs.User.GetRepliesResponse, LemmyGenericError>) -> Void
    ) {

        return requestDecodable(
            path: LemmyEndpoint.User.getReplies.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion
        )
    }

    func getUserMentions(
        parameters: LemmyApiStructs.User.GetUserMentionsRequest,
        completion: @escaping (Result<LemmyApiStructs.User.GetUserMentionsResponse, LemmyGenericError>) -> Void
    ) {

        return requestDecodable(
            path: LemmyEndpoint.User.getUserMentions.endpoint,
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
            path: LemmyEndpoint.User.markUserMentionAsRead.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion
        )
    }
}
