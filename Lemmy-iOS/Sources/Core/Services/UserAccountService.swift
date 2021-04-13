//
//  UserAccountService.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 14.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

protocol UserAccountSerivceProtocol {
    var currentLocalUser: LMModels.Views.LocalUserSettingsView? { get set }
    var currentUserPersonID: LMModels.Source.LocalUserSettings.ID? { get }
    var isAuthorized: Bool { get }
    var jwtToken: String? { get set }

    func logOut()
    func userLogout() // logout but not clearing currentInstanceUrl
}

// wrapper 
final class UserAccountService: UserAccountSerivceProtocol {
    var currentLocalUser: LMModels.Views.LocalUserSettingsView? {
        get { LemmyShareData.shared.userdata }
        set { LemmyShareData.shared.userdata = newValue }
    }
    
    var currentUserPersonID: LMModels.Source.LocalUserSettings.ID? { LemmyShareData.shared.userdata?.person.id }
    
    var jwtToken: String? {
        get { LemmyShareData.shared.jwtToken }
        set { LemmyShareData.shared.jwtToken = newValue }
    }
    
    var isAuthorized: Bool { LemmyShareData.shared.isLoggedIn }
    
    func logOut() { LemmyShareData.shared.loginData.logout() }
    
    func userLogout() { LemmyShareData.shared.loginData.userLogout() }
}
