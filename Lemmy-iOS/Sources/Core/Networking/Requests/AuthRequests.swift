//
//  AuthRequests.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/14/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation
import Combine

extension RequestsManager {
    func asyncLogin(
        parameters: LMModels.Api.User.Login
    ) -> AnyPublisher<LMModels.Api.User.LoginResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Authentication.login.endpoint, parameters: parameters)
    }
    
    func asyncRegister(
        parameters: LMModels.Api.User.Register
    ) -> AnyPublisher<LMModels.Api.User.LoginResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Authentication.register.endpoint, parameters: parameters)
    }
    
    func asyncGetCaptcha() -> AnyPublisher<LMModels.Api.User.GetCaptchaResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Authentication.getCaptcha.endpoint,
                              parameters: LMModels.Api.User.GetCaptcha())
    }
}
