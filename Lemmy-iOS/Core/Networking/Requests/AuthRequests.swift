//
//  AuthRequests.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/14/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

private protocol AuthRequestManagerProtocol {
    func login(
        parameters: LemmyApiStructs.Authentication.LoginRequest,
        completion: @escaping (Result<LemmyApiStructs.Authentication.LoginResponse, LemmyGenericError>) -> Void
    )
    
    func register(
        parameters: LemmyApiStructs.Authentication.RegisterRequest,
        completion: @escaping (Result<LemmyApiStructs.Authentication.RegisterResponse, LemmyGenericError>) -> Void
    )
    
    func getCaptcha(
        completion: @escaping (Result<LemmyApiStructs.Authentication.GetCaptchaResponse, LemmyGenericError>) -> Void
    )
}

extension RequestsManager: AuthRequestManagerProtocol {
    func login(
        parameters: LemmyApiStructs.Authentication.LoginRequest,
        completion: @escaping (Result<LemmyApiStructs.Authentication.LoginResponse, LemmyGenericError>) -> Void
    ) {
        
        return requestDecodable(
            path: LemmyEndpoint.Authentication.login.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion
        )
    }

    func register(
        parameters: LemmyApiStructs.Authentication.RegisterRequest,
        completion: @escaping (Result<LemmyApiStructs.Authentication.RegisterResponse, LemmyGenericError>) -> Void
    ) {

        return requestDecodable(
            path: LemmyEndpoint.Authentication.register.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion
        )
    }

    func getCaptcha(
        completion: @escaping (Result<LemmyApiStructs.Authentication.GetCaptchaResponse, LemmyGenericError>) -> Void
    ) {

        // EXTRA: here is "ok" rootKey
        return requestDecodable(
            path: LemmyEndpoint.Authentication.getCaptcha.endpoint,
            parameters: LemmyApiStructs.Authentication.GetCaptchaRequest?.none,
            parsingFromRootKey: "data",
            completion: completion
        )
    }
}
