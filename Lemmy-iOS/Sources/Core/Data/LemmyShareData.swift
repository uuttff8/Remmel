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
    
    var unauthUserDefaults: UserDefaults { loginData.authUserDefaults }
    
    var authUserDefaults: UserDefaults { loginData.unauthUserDefaults }
    
    var userdata: LMModels.Views.LocalUserSettingsView? {
        get {
            guard let data = unauthUserDefaults.data(forKey: UserDefaults.Key.userdata) else { return nil }
            return try? LemmyJSONDecoder().decode(LMModels.Views.LocalUserSettingsView.self, from: data)
        } set {
            let data = try? LMMJSONEncoder().encode(newValue)
            unauthUserDefaults.set(data, forKey: UserDefaults.Key.userdata)
        }
    }
    
    var jwtToken: String? {
        get { loginData.jwtToken }
        set { loginData.jwtToken = newValue }
    }
    
    var isLoggedIn: Bool {
        self.userdata != nil && self.jwtToken != nil
    }
    
    var currentInstanceUrl: InstanceUrl? {
        get {
            // support for old versions
            let supportUrl = self.unauthUserDefaults.string(forKey: UserDefaults.Key.currentInstanceUrlOld)
            
            guard supportUrl == nil, supportUrl?.isEmpty == true else {
                
                // if found old fashioned currentInstanceUrl (haha)
                // then nullify this old value
                // and try to create a new fashioned InstanceUrl

                guard let correctNewUrl = supportUrl,
                        correctNewUrl.contains(".")
                else { return nil }
                
                self.unauthUserDefaults.setNilValueForKey(UserDefaults.Key.currentInstanceUrlOld)
                self.unauthUserDefaults.set(InstanceUrl(string: correctNewUrl), forKey: UserDefaults.Key.currentInstanceUrlLast)
                
                return InstanceUrl(string: correctNewUrl)
            }
            
            guard let data = unauthUserDefaults.data(forKey: UserDefaults.Key.currentInstanceUrlLast) else {
                return nil
            }
            
            return try? LemmyJSONDecoder().decode(InstanceUrl.self, from: data)
        }
        set {
            let data = try? LMMJSONEncoder().encode(newValue)
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
        get { self.unauthUserDefaults.array(forKey: UserDefaults.Key.blockedUsersId) as? [Int] ?? [] }
        set { self.unauthUserDefaults.setValue(newValue, forKey: UserDefaults.Key.blockedUsersId) }
    }
    
    var needsAppOnboarding: Bool {
        get { self.authUserDefaults.bool(forKey: UserDefaults.Key.needsAppOnboarding) }
        set { self.authUserDefaults.setValue(newValue, forKey: UserDefaults.Key.needsAppOnboarding) }
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
        guard let host = Self.isLinkCorrect(string) else { return nil }
        self.rawHost = host
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
    
    static func isLinkCorrect(_ str: String) -> String? {
        guard let url = URL(string: str) else { return nil }
        return Self.isLinkCorrect(url)
    }
    
    static func isLinkCorrect(_ url: URL) -> String? {
        guard url.host?.contains(".") == true else { return nil }
        return url.host?.lowercased()
    }
}
