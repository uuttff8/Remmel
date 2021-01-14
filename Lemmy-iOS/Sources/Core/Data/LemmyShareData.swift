//
//  LemmyShareData.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/13/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

// work after auth
class LemmyShareData {
    
    static let shared = LemmyShareData()
    
    let loginData = LoginData.shared
    
    enum Key {
        static let jwt = "jwt"
        static let userId = "userId"
        static let userdata = "userdata"
        static let currentInstanceUrl = "currentInstanceUrl"
        static let blockedUsersId = "blockedUsersId"
    }
    
    let userDefaults = UserDefaults.appShared
    
    var userdata: LemmyModel.MyUser? {
        get {
            guard let data = userDefaults.data(forKey: Key.userdata)
            else {
                return nil
            }
            
            return try? LemmyJSONDecoder().decode(LemmyModel.MyUser.self, from: data)
        } set {
            let encoder = JSONEncoder()
            let dateFormatter = DateFormatter().then {
                $0.dateFormat = Date.lemmyDateFormat
                $0.locale = Locale(identifier: "en_US_POSIX")
            }
            encoder.dateEncodingStrategy = .formatted(dateFormatter)
            
            let data = try? encoder.encode(newValue)
            userDefaults.set(data, forKey: Key.userdata)
        }
    }
    
    var jwtToken: String? {
        loginData.jwtToken
    }
    
    var isLoggedIn: Bool {
        self.userdata != nil && self.jwtToken != nil
    }
    
    var currentInstanceUrl: String {
        get { self.userDefaults.string(forKey: Key.currentInstanceUrl) ?? "" }
        set { self.userDefaults.setValue(newValue, forKey: Key.currentInstanceUrl) }
    }
    
    var blockedUsersId: [Int] {
        get { self.userDefaults.array(forKey: Key.blockedUsersId) as? [Int] ?? [] }
        set { self.userDefaults.setValue(newValue, forKey: Key.blockedUsersId) }
    }
}
