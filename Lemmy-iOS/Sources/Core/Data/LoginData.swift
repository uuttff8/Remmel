//
//  LoginData.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation
import KeychainSwift

private let authSuiteName = "userDefaults.uuttff8.LemmyiOS"
private let unauthSuiteName = "userDefaults.uuttff8.LemmyiOS.user"

extension UserDefaults {
    enum Key {
        static let jwt = "jwt"
        static let userId = "userId"
        static let userdata = "userdata"
        static let currentInstanceUrlOld = "currentInstanceUrl"
        static let currentInstanceUrlLast = "currentInstanceUrlTwo"
        static let blockedUsersId = "blockedUsersId"
        
        static let needsAppOnboarding = "needsAppOnboarding"
    }
        
    static var authShared = UserDefaults(suiteName: authSuiteName)!
    
    static var unauthShared: UserDefaults {
        let userDefaults = UserDefaults(suiteName: unauthSuiteName)!
        
        userDefaults.register(defaults: [
            Key.needsAppOnboarding: true
        ])
        
        return userDefaults
    }
}

class LoginData {
    static let shared = LoginData()

    private let keychain = KeychainSwift()
    
    let authUserDefaults = UserDefaults.authShared
    let unauthUserDefaults = UserDefaults.unauthShared

    func login(jwt: String) {
        self.jwtToken = jwt
    }

    func logout() {
        ApiManager.chainedWsCLient.close()
        self.clear()
        authUserDefaults.resetDefaults()
        URLCache.shared.removeAllCachedResponses()
    }
    
    // delete all except currentInstance URL
    func userLogout() {
        let currInstance = LemmyShareData.shared.currentInstanceUrl
        self.clear()
        authUserDefaults.resetDefaults()
        URLCache.shared.removeAllCachedResponses()
        LemmyShareData.shared.currentInstanceUrl = currInstance
    }
    
    var isLoggedIn: Bool {
        jwtToken != nil && userId != nil
    }

    var jwtToken: String? {
        get { keychain.get(UserDefaults.Key.jwt) }
        set { keychain.set(newValue ?? "", forKey: UserDefaults.Key.jwt) }
    }

    var userId: LMModels.Source.LocalUserSettings.ID? {
        get { authUserDefaults.integer(forKey: UserDefaults.Key.userId) }
        set { authUserDefaults.set(newValue, forKey: UserDefaults.Key.userId) }
    }

    func clear() {
        authUserDefaults.removeSuite(named: authSuiteName)
        keychain.clear()
    }
}
