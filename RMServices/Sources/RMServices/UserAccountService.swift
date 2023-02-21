//
//  UserAccountService.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 14.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation
import RMModels
import RMFoundation

public protocol UserAccountServiceProtocol {
    var currentUserInfo: RMModels.Api.Site.MyUserInfo? { get set }
    var currentUserPersonID: RMModels.Source.LocalUserSettings.ID? { get }
    var isAuthorized: Bool { get }
    var jwtToken: String? { get set }

    func logOut()
    func userLogout() // logout but not clearing currentInstanceUrl
}

// wrapper 
public final class UserAccountService: UserAccountServiceProtocol {
    
    public init() {}
    
    public var currentUserInfo: RMModels.Api.Site.MyUserInfo? {
        get { LemmyShareData.shared.userdata }
        set { LemmyShareData.shared.userdata = newValue }
    }
    
    public var currentUserPersonID: RMModels.Source.LocalUserSettings.ID? {
        LemmyShareData.shared.userdata?.localUserView.person.id
    }
    
    public var jwtToken: String? {
        get { LemmyShareData.shared.jwtToken }
        set { LemmyShareData.shared.jwtToken = newValue }
    }
    
    public var isAuthorized: Bool { LemmyShareData.shared.isLoggedIn }
    
    public func logOut() { LemmyShareData.shared.loginData.logout() }
    
    public func userLogout() { LemmyShareData.shared.loginData.userLogout() }
}
