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
    
    let loginData = LoginData()
    
    enum Constants {
        static let accessToken = "access_token"
        static let userId = "userId"
        static let userdata = "userdata"
    }
    
    let userDefaults = UserDefaults.appShared
    
    var userdata: LemmyApiStructs.UserView? {
        get {
            guard let data = userDefaults.data(forKey: Constants.userdata)
                else { return nil }
            return try? JSONDecoder().decode(LemmyApiStructs.UserView.self, from: data)
        } set {
            let data = try? JSONEncoder().encode(newValue)
            userDefaults.set(data, forKey: Constants.userdata)
        }
    }
}
