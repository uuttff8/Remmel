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
        ApiManager.chainedWsCLient?.close()
        self.clear()
        userDefaults.resetDefaults()
        URLCache.shared.removeAllCachedResponses()
    }
    
    // delete all except currentInstance URL
    func userLogout() {
        let currInstance = LemmyShareData.shared.currentInstanceUrl
        self.clear()
        userDefaults.resetDefaults()
        URLCache.shared.removeAllCachedResponses()
        LemmyShareData.shared.currentInstanceUrl = currInstance
    }
    
    var isLoggedIn: Bool {
        jwtToken != nil && userId != nil
    }

    var jwtToken: String? {
        get { keychain.get(LemmyShareData.Key.jwt) }
        set { keychain.set(newValue!, forKey: LemmyShareData.Key.jwt) }
    }

    var userId: LMModels.Source.UserSafeSettings.ID? {
        get { userDefaults.integer(forKey: LemmyShareData.Key.userId) }
        set { userDefaults.set(newValue, forKey: LemmyShareData.Key.userId) }
    }

    func clear() {
        userDefaults.removeSuite(named: UserDefaults.appSuiteName)
        keychain.clear()
    }
}
