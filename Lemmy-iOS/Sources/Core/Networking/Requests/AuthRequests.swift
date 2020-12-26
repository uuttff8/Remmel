//
//  AuthRequests.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/14/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation
import Combine

private protocol AuthRequestManagerProtocol {
    func asyncLogin(
        parameters: LemmyModel.Authentication.LoginRequest
    ) -> AnyPublisher<LemmyModel.Authentication.LoginResponse, LemmyGenericError>
    
    func asyncRegister(
        parameters: LemmyModel.Authentication.RegisterRequest
    ) -> AnyPublisher<LemmyModel.Authentication.RegisterResponse, LemmyGenericError>
    
    func asyncGetCaptcha() -> AnyPublisher<LemmyModel.Authentication.GetCaptchaResponse, LemmyGenericError>

}

extension RequestsManager: AuthRequestManagerProtocol {    
    func asyncLogin(
        parameters: LemmyModel.Authentication.LoginRequest
    ) -> AnyPublisher<LemmyModel.Authentication.LoginResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Authentication.login.endpoint, parameters: parameters)
    }
    
    func asyncRegister(
        parameters: LemmyModel.Authentication.RegisterRequest
    ) -> AnyPublisher<LemmyModel.Authentication.RegisterResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Authentication.register.endpoint, parameters: parameters)
    }
    
    func asyncGetCaptcha() -> AnyPublisher<LemmyModel.Authentication.GetCaptchaResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Authentication.getCaptcha.endpoint,
                              parameters: LemmyModel.Authentication.GetCaptchaRequest?.none)
    }
}
