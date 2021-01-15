//
//  LMModels+Others.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 15.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

extension LMModels {
    enum Others {
        
        enum SortType: String, Codable {
            case active = "Active"
            case hot = "Hot"
            case new = "New"
            case topDay = "TopDay"
            case topWeek = "TopWeek"
            case topMonth = "TopMonth"
            case TopYear = "TopYear"
            case TopAll = "TopAll"
        }
        
        enum ListingType: String, Codable {
            case all = "All"
            case local = "Local"
            case subscribed = "Subscribed"
            case community = "Community"
        }
        
        enum SearchType: String, Codable {
            case all = "All"
            case comments = "Comments"
            case posts = "Posts"
            case communities = "Communities"
            case users = "Users"
            case url = "Url"
        }
        
        struct WebSocketResponse<ResponseType: Codable> {
            let op: String
            let data: ResponseType
        }
        
        struct WebSocketJsonResponse<ResponseType: Codable> {
            let op: String?
            let data: ResponseType?
            let error: String?
            let reconnect: Bool?
        }
        
    }
}
