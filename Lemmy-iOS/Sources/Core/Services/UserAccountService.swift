//
//  UserAccountService.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 14.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol UserAccountSerivceProtocol {
    var currentUser: LMModels.Source.UserSafeSettings? { get }
    var currentUserID: LMModels.Source.UserSafeSettings.ID? { get }
    var isAuthorized: Bool { get }
    var jwtToken: String? { get }

    func logOut()
    func userLogout()
}

// wrapper 
final class UserAccountService: UserAccountSerivceProtocol {
    var currentUser: LMModels.Source.UserSafeSettings? { LemmyShareData.shared.userdata }
    
    var currentUserID: LMModels.Source.UserSafeSettings.ID? { LemmyShareData.shared.loginData.userId }
    
    var jwtToken: String? { LemmyShareData.shared.jwtToken }
    
    var isAuthorized: Bool { LemmyShareData.shared.isLoggedIn }
    
    func logOut() { LemmyShareData.shared.loginData.logout() }
    
    func userLogout() { LemmyShareData.shared.loginData.userLogout() }
}
