//
//  AuthRequests.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/14/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

private protocol AuthRequestManagerProtocol {
    func login<Req: Codable, Res: Codable>(parameters: Req, completion: @escaping (Result<Res, LemmyGenericError>) -> Void)
    func register<Req: Codable, Res: Codable>(parameters: Req, completion: @escaping (Result<Res, LemmyGenericError>) -> Void)
    func getCaptcha<Res: Codable>(completion: @escaping (Result<Res, LemmyGenericError>) -> Void)
}

extension RequestsManager: AuthRequestManagerProtocol {
    func login<Req, Res>(
        parameters: Req,
        completion: @escaping (Result<Res, LemmyGenericError>) -> Void
    ) where Req: Codable, Res: Codable {

        return requestDecodable(
            path: LemmyEndpoint.Authentication.login.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion
        )
    }

    func register<Req, Res>(
        parameters: Req,
        completion: @escaping (Result<Res, LemmyGenericError>) -> Void
    ) where Req: Codable, Res: Codable {

        return requestDecodable(
            path: LemmyEndpoint.Authentication.register.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion
        )
    }

    func getCaptcha<Res>(
        completion: @escaping (Result<Res, LemmyGenericError>) -> Void
    ) where Res: Codable {

        // EXTRA: here is "ok" rootKey
        return requestDecodable(
            path: LemmyEndpoint.Authentication.getCaptcha.endpoint,
            parameters: LemmyApiStructs.Authentication.GetCaptchaRequest?.none,
            parsingFromRootKey: "data",
            completion: completion
        )
    }
}
