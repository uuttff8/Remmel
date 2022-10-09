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
    
    var authUserDefaults: UserDefaults { loginData.authUserDefaults }
    
    var unauthUserDefaults: UserDefaults { loginData.unauthUserDefaults }
    
    var userdata: LMModels.Api.Site.MyUserInfo? {
        get {
            guard let data = authUserDefaults.data(forKey: UserDefaults.Key.userdata) else {
                return nil
            }
            return try? LemmyJSONDecoder().decode(LMModels.Api.Site.MyUserInfo.self, from: data)
        } set {
            let data = try? LemmyJSONEncoder().encode(newValue)
            authUserDefaults.set(data, forKey: UserDefaults.Key.userdata)
        }
    }
    
    var jwtToken: String? {
        get { loginData.jwtToken }
        set { loginData.jwtToken = newValue }
    }
    
    var isLoggedIn: Bool {
        self.userdata != nil && self.jwtToken != nil && self.currentInstanceUrl != nil
    }
    
    var currentInstanceUrl: InstanceUrl? {
        get {
            // support for old versions
            let supportUrl = self.unauthUserDefaults.string(forKey: UserDefaults.Key.currentInstanceUrlOld)
            
            guard supportUrl == nil else {
                
                // if found old fashioned currentInstanceUrl (haha)
                // then nullify this old value
                // and try to create a new fashioned InstanceUrl
                
                self.unauthUserDefaults.removeObject(forKey: UserDefaults.Key.currentInstanceUrlOld)

                guard let newUrl = supportUrl,
                      let newInstanceUrl = InstanceUrl(string: newUrl)
                else { return nil }
                                
                let data = try? LemmyJSONEncoder().encode(newInstanceUrl)
                unauthUserDefaults.set(data, forKey: UserDefaults.Key.currentInstanceUrlLast)
                
                return newInstanceUrl
            }
            
            guard let data = unauthUserDefaults.data(forKey: UserDefaults.Key.currentInstanceUrlLast) else {
                return nil
            }
            
            return try? LemmyJSONDecoder().decode(InstanceUrl.self, from: data)
        }
        set {
            let data = try? LemmyJSONEncoder().encode(newValue)
            unauthUserDefaults.set(data, forKey: UserDefaults.Key.currentInstanceUrlLast)
        }
    }
    
    var authedInstanceUrl: InstanceUrl {
        guard let url = currentInstanceUrl else {
            Logger.common.error("currentInstanceUrl in authed zone is nil, very bad!")
            fatalError("currentInstanceUrl in authed zone is nil, very bad!")
        }
        
        return url
    }
    
    var blockedUsersId: [Int] {
        get { self.authUserDefaults.array(forKey: UserDefaults.Key.blockedUsersId) as? [Int] ?? [] }
        set { self.authUserDefaults.setValue(newValue, forKey: UserDefaults.Key.blockedUsersId) }
    }
    
    var needsAppOnboarding: Bool {
        get { self.unauthUserDefaults.bool(forKey: UserDefaults.Key.needsAppOnboarding) }
        set { self.unauthUserDefaults.setValue(newValue, forKey: UserDefaults.Key.needsAppOnboarding) }
    }
}

struct InstanceUrl: Codable {
    
    // raw link without any http or ws protocols
    // example: lemmy.ml
    // wrong example: https://lemmy.ml/
    let rawHost: String
    
    /// Parameters:
    /// - baseUrl: The base url that should be handled
    init?(string: String) {
        var link = string
            .replacingOccurrences(of: "https://", with: "")
            .replacingOccurrences(of: "http://", with: "")
            .replacingOccurrences(of: "wss://", with: "")
        
        if link.contains("/"), let firstIndex = link.firstIndex(of: "/") {
            link.removeSubrange(firstIndex..<link.endIndex)
        }
        
        self.rawHost = link
    }
    
    var wssLink: String {
        "wss://" + rawHost + "/api/v3/ws"
    }
    
    var httpLink: String {
        "https://" + rawHost + "/"
    }
    
    var withoutSchemeLink: String {
        rawHost + "/"
    }
}
