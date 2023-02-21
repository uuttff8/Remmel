//
//  AuthRequests.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/14/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation
import Combine
import RMFoundation
import RMModels

public extension RequestsManager {
    func asyncLogin(
        parameters: RMModels.Api.Person.Login
    ) -> AnyPublisher<RMModels.Api.Person.LoginResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Authentication.login.endpoint, parameters: parameters)
    }
    
    func asyncRegister(
        parameters: RMModels.Api.Person.Register
    ) -> AnyPublisher<RMModels.Api.Person.LoginResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Authentication.register.endpoint, parameters: parameters)
    }
    
    func asyncGetCaptcha() -> AnyPublisher<RMModels.Api.Person.GetCaptchaResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Authentication.getCaptcha.endpoint,
                              parameters: RMModels.Api.Person.GetCaptcha())
    }
}
