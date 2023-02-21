//
//  LoginData.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation
import KeychainSwift
import RMModels

private let authSuiteName = "userDefaults.uuttff8.LemmyiOS"
private let unauthSuiteName = "userDefaults.uuttff8.LemmyiOS.user"

public extension UserDefaults {
    enum Key {
        static let jwt = "jwt"
        static let userId = "userId"
        static let userdata = "userdata"
        static let currentInstanceUrlOld = "currentInstanceUrl"
        static let currentInstanceUrlLast = "currentInstanceUrlTwo"
        static let blockedUsersId = "blockedUsersId"
        
        static let needsAppOnboarding = "needsAppOnboarding"
    }

    // swiftlint:disable:next force_unwrapping
    static var authShared = UserDefaults(suiteName: authSuiteName)!
    static var unauthShared: UserDefaults {
        // swiftlint:disable:next force_unwrapping
        let userDefaults = UserDefaults(suiteName: unauthSuiteName)!
        
        userDefaults.register(defaults: [
            Key.needsAppOnboarding: true
        ])
        
        return userDefaults
    }
}

public class LoginData {
    public static let shared = LoginData()

    private let keychain = KeychainSwift()
    
    public let authUserDefaults = UserDefaults.authShared
    public let unauthUserDefaults = UserDefaults.unauthShared

    public func login(jwt: String) {
        self.jwtToken = jwt
    }

    public func logout() {
//        ApiManager.chainedWsCLient.close()
        self.clear()
        authUserDefaults.resetDefaults()
        URLCache.shared.removeAllCachedResponses()
    }
    
    // delete all except currentInstance URL
    public func userLogout() {
        let currInstance = LemmyShareData.shared.currentInstanceUrl
        self.clear()
        authUserDefaults.resetDefaults()
        URLCache.shared.removeAllCachedResponses()
        LemmyShareData.shared.currentInstanceUrl = currInstance
    }
    
    public var isLoggedIn: Bool {
        jwtToken != nil && userId != nil
    }

    public var jwtToken: String? {
        get { keychain.get(UserDefaults.Key.jwt) }
        set { keychain.set(newValue ?? "", forKey: UserDefaults.Key.jwt) }
    }

    public var userId: RMModels.Source.LocalUserSettings.ID? {
        get { authUserDefaults.integer(forKey: UserDefaults.Key.userId) }
        set { authUserDefaults.set(newValue, forKey: UserDefaults.Key.userId) }
    }

    public func clear() {
        authUserDefaults.removeSuite(named: authSuiteName)
        keychain.clear()
    }
}
