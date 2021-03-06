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
    
    var userDefaults: UserDefaults {
        loginData.userDefaults
    }
    
    var userdata: LMModels.Source.UserSafeSettings? {
        get {
            guard let data = userDefaults.data(forKey: UserDefaults.Key.userdata)
            else {
                return nil
            }
            
            return try? LemmyJSONDecoder().decode(LMModels.Source.UserSafeSettings.self, from: data)
        } set {
            let encoder = JSONEncoder()
            let dateFormatter = DateFormatter().then {
                $0.dateFormat = Date.lemmyDateFormat
                $0.locale = Locale(identifier: "en_US_POSIX")
            }
            encoder.dateEncodingStrategy = .formatted(dateFormatter)
            
            let data = try? encoder.encode(newValue)
            userDefaults.set(data, forKey: UserDefaults.Key.userdata)
        }
    }
    
    var jwtToken: String? {
        get { loginData.jwtToken }
        set { loginData.jwtToken = newValue }
    }
    
    var isLoggedIn: Bool {
        self.userdata != nil && self.jwtToken != nil
    }
    
    var currentInstanceUrl: String {
        get { self.userDefaults.string(forKey: UserDefaults.Key.currentInstanceUrl)?.lowercased() ?? "" }
        set { self.userDefaults.setValue(newValue, forKey: UserDefaults.Key.currentInstanceUrl) }
    }
    
    var blockedUsersId: [Int] {
        get { self.userDefaults.array(forKey: UserDefaults.Key.blockedUsersId) as? [Int] ?? [] }
        set { self.userDefaults.setValue(newValue, forKey: UserDefaults.Key.blockedUsersId) }
    }
    
    var needsAppOnboarding: Bool {
        get { self.userDefaults.bool(forKey: UserDefaults.Key.needsAppOnboarding) }
        set { self.userDefaults.setValue(newValue, forKey: UserDefaults.Key.needsAppOnboarding) }
    }
}
