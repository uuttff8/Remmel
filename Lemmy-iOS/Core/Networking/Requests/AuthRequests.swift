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
        parameters: LemmyModel.Authentication.LoginRequest,
        completion: @escaping (Result<LemmyModel.Authentication.LoginResponse, LemmyGenericError>) -> Void
    )
    
    func register(
        parameters: LemmyModel.Authentication.RegisterRequest,
        completion: @escaping (Result<LemmyModel.Authentication.RegisterResponse, LemmyGenericError>) -> Void
    )
    
    func getCaptcha(
        completion: @escaping (Result<LemmyModel.Authentication.GetCaptchaResponse, LemmyGenericError>) -> Void
    )
}

extension RequestsManager: AuthRequestManagerProtocol {
    func login(
        parameters: LemmyModel.Authentication.LoginRequest,
        completion: @escaping (Result<LemmyModel.Authentication.LoginResponse, LemmyGenericError>) -> Void
    ) {
        
        return requestDecodable(
            path: WSEndpoint.Authentication.login.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion
        )
    }

    func register(
        parameters: LemmyModel.Authentication.RegisterRequest,
        completion: @escaping (Result<LemmyModel.Authentication.RegisterResponse, LemmyGenericError>) -> Void
    ) {

        return requestDecodable(
            path: WSEndpoint.Authentication.register.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion
        )
    }

    func getCaptcha(
        completion: @escaping (Result<LemmyModel.Authentication.GetCaptchaResponse, LemmyGenericError>) -> Void
    ) {

        // EXTRA: here is "ok" rootKey
        return requestDecodable(
            path: WSEndpoint.Authentication.getCaptcha.endpoint,
            parameters: LemmyModel.Authentication.GetCaptchaRequest?.none,
            parsingFromRootKey: "data",
            completion: completion
        )
    }
}
