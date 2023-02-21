//
//  Keys.swift
//  Remmel
//
//  Created by uuttff8 on 21/02/2023.
//  Copyright © 2023 Anton Kuzmin. All rights reserved.
//

import Foundation
import RMNetworking
import RMServices

private struct NetworkProviderKey: InjectionKey {
    static var currentValue: WSClientProtocol = ApiManager.chainedWsCLient
}

private struct UserAccountProviderKey: InjectionKey {
    static var currentValue: UserAccountServiceProtocol = UserAccountService()
}

extension InjectedValues {
    var networkProvider: WSClientProtocol {
        get { Self[NetworkProviderKey.self] }
        set { Self[NetworkProviderKey.self] = newValue }
    }
    
    var currentAccountProvider: UserAccountServiceProtocol {
        get { Self[UserAccountProviderKey.self] }
        set { Self[UserAccountProviderKey.self] = newValue }
    }
}
