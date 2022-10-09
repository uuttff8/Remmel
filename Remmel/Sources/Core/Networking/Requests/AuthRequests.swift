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
        parameters: LMModels.Api.Person.Login
    ) -> AnyPublisher<LMModels.Api.Person.LoginResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Authentication.login.endpoint, parameters: parameters)
    }
    
    func asyncRegister(
        parameters: LMModels.Api.Person.Register
    ) -> AnyPublisher<LMModels.Api.Person.LoginResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Authentication.register.endpoint, parameters: parameters)
    }
    
    func asyncGetCaptcha() -> AnyPublisher<LMModels.Api.Person.GetCaptchaResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Authentication.getCaptcha.endpoint,
                              parameters: LMModels.Api.Person.GetCaptcha())
    }
}
