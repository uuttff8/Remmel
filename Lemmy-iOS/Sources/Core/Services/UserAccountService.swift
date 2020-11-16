//
//  UserAccountService.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 14.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol UserAccountSerivceProtocol {
    var currentUser: LemmyModel.MyUser? { get }
    var currentUserID: LemmyModel.MyUser.UserId? { get }
    var isAuthorized: Bool { get }
    var jwtToken: String? { get }

    func logOut()
}

// wrapper 
final class UserAccountService: UserAccountSerivceProtocol {
    var currentUser: LemmyModel.MyUser? { LemmyShareData.shared.userdata }
    
    var currentUserID: LemmyModel.MyUser.UserId? { LemmyShareData.shared.loginData.userId }
    
    var jwtToken: String? { LemmyShareData.shared.jwtToken }
    
    var isAuthorized: Bool { LemmyShareData.shared.loginData.isLoggedIn }
    
    func logOut() { LemmyShareData.shared.loginData.logout() }
}
