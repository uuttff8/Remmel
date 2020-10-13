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
    private let shareData = LemmyShareData()
    
    func logout() {
        keychain.clear()
        userDefaults.removeSuite(named: UserDefaults.appSuiteName)
        userDefaults.resetDefaults()
        URLCache.shared.removeAllCachedResponses()
    }
    
    func setLoggedIn(_ userId:String) {
        self.userId = userId
    }
    
    var currentUser: LemmyApiStructs.UserView? {
        shareData.userdata
    }
    
    // LEGACY
    func isLoggedIn() -> Bool {
        return accessToken != nil && userId != nil
    }
    
    var accessToken: String? {
        get { keychain.get(LemmyShareData.Constants.accessToken) }
        set { keychain.set(newValue!, forKey: LemmyShareData.Constants.accessToken) }
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
