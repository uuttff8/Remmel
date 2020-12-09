//
//  LoginData.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation
import KeychainSwift

extension UserDefaults {
    static let appSuiteName = "userDefaults.uuttff8.LemmyiOS"

    static var appShared: UserDefaults {
        UserDefaults(suiteName: UserDefaults.appSuiteName)!
    }
}

class LoginData {
    static let shared = LoginData()

    private let keychain = KeychainSwift()
    private let userDefaults = UserDefaults.appShared

    func login(jwt: String) {
        self.jwtToken = jwt
    }

    func logout() {
        self.clear()
        userDefaults.resetDefaults()
        URLCache.shared.removeAllCachedResponses()
    }
    
    var isLoggedIn: Bool {
        jwtToken != nil && userId != nil
    }

    var jwtToken: String? {
        get { keychain.get(LemmyShareData.Constants.jwt) }
        set { keychain.set(newValue!, forKey: LemmyShareData.Constants.jwt) }
    }

    var userId: LemmyModel.MyUser.UserId? {
        get { userDefaults.integer(forKey: LemmyShareData.Constants.userId) }
        set { userDefaults.set(newValue, forKey: LemmyShareData.Constants.userId) }
    }

    func clear() {
        userDefaults.removeSuite(named: UserDefaults.appSuiteName)
        keychain.clear()
    }
}
