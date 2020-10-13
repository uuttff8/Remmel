//
//  UserRequests.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/14/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

private protocol UserRequestManagerProtocol {
    func getUserDetails<Req: Codable, Res: Codable>(parameters: Req, completion: @escaping (Result<Res, Error>) -> Void)
    func saveUserSettings<Req: Codable, Res: Codable>(parameters: Req, completion: @escaping (Result<Res, Error>) -> Void)
    func getReplies<Req: Codable, Res: Codable>(parameters: Req, completion: @escaping (Result<Res, Error>) -> Void)
    func getUserMentions<Req: Codable, Res: Codable>(parameters: Req, completion: @escaping (Result<Res, Error>) -> Void)
    func markUserMentionAsRead<Req: Codable, Res: Codable>(parameters: Req, completion: @escaping (Result<Res, Error>) -> Void)
}

extension RequestsManager: UserRequestManagerProtocol {
    func getUserDetails<Req, Res>(
        parameters: Req,
        completion: @escaping (Result<Res, Error>) -> Void
    ) where Req : Codable, Res : Codable {
        
        return requestDecodable(
            path: LemmyEndpoint.User.getUserDetails.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion
        )
    }
    
    func saveUserSettings<Req, Res>(
        parameters: Req,
        completion: @escaping (Result<Res, Error>) -> Void
    ) where Req : Codable, Res : Codable {
        
        return requestDecodable(
            path: LemmyEndpoint.User.saveUserSettings.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion
        )
    }
    
    func getReplies<Req, Res>(
        parameters: Req,
        completion: @escaping (Result<Res, Error>) -> Void
    ) where Req : Codable, Res : Codable {
        
        return requestDecodable(
            path: LemmyEndpoint.User.getReplies.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion
        )
    }
    
    func getUserMentions<Req, Res>(
        parameters: Req,
        completion: @escaping (Result<Res, Error>) -> Void
    ) where Req : Codable, Res : Codable {
        
        return requestDecodable(
            path: LemmyEndpoint.User.getUserMentions.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion
        )
    }
    
    func markUserMentionAsRead<Req, Res>(
        parameters: Req,
        completion: @escaping (Result<Res, Error>) -> Void
    ) where Req : Codable, Res : Codable {
        
        return requestDecodable(
            path: LemmyEndpoint.User.markUserMentionAsRead.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion
        )
    }
}
