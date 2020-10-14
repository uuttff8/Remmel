//
//  LemmyApiStructs+Site.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/14/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

extension LemmyApiStructs {
    enum Site {
        
        // MARK: - GetSite -
        struct GetSiteRequest: Codable, Equatable {
            let auth: String?
        }
        
        struct GetSiteResponse: Codable, Equatable {
            let site: SiteView?
            let admins: Array<UserView>
            let banned: Array<UserView>
            let online: Int // broken as of 10.14.2020
            let version: String
            let myUser: MyUser? // Gives back your user and settings if logged in
            
            enum CodingKeys: String, CodingKey {
                case site, admins, banned, online, version
                case myUser = "my_user"
            }
        }
    }
}
