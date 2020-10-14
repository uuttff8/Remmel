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
    private let keychain = KeychainSwift()
    private let userDefaults = UserDefaults.appShared
    private let shareData = LemmyShareData()
    
    func login(jwt: String) {
        self.jwtToken = jwt
    }
    
    func logout() {
        self.clear()
        userDefaults.removeSuite(named: UserDefaults.appSuiteName)
        userDefaults.resetDefaults()
        URLCache.shared.removeAllCachedResponses()
    }
    
    var currentUser: LemmyApiStructs.MyUser? {
        shareData.userdata
    }
    
    // LEGACY
    func isLoggedIn() -> Bool {
        return jwtToken != nil && userId != nil
    }
    
    var jwtToken: String? {
        get { keychain.get(LemmyShareData.Constants.jwt) }
        set { keychain.set(newValue!, forKey: LemmyShareData.Constants.jwt) }
    }
    
    var userId: String? {
        get { userDefaults.string(forKey: LemmyShareData.Constants.userId) }
        set { userDefaults.set(newValue, forKey: LemmyShareData.Constants.userId) }
    }

    func clear() {
        keychain.clear()
        clearUserId()
    }
    
    private func clearUserId() {
        userDefaults.removeObject(forKey: LemmyShareData.Constants.userId)
    }
}
