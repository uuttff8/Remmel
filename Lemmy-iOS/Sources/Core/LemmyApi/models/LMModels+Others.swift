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
        
        enum SortType: String, Codable, CaseIterable, LemmyTypePickable {
            case active = "Active"
            case hot = "Hot"
            case new = "New"
            case topDay = "TopDay"
            case topWeek = "TopWeek"
            case topMonth = "TopMonth"
            case topYear = "TopYear"
            case topAll = "TopAll"
            
            var label: String {
                switch self {
                case .active: return "sort-active".localized
                case .hot: return "sort-hot".localized
                case .new: return "sort-new".localized
                case .topDay: return "sort-day".localized
                case .topWeek: return "sort-week".localized
                case .topMonth: return "sort-month".localized
                case .topYear: return "sort-year".localized
                case .topAll: return "sort-all".localized
                }
            }
        }
        
        enum ListingType: String, Codable, LemmyTypePickable {
            case all = "All"
            case local = "Local"
            case subscribed = "Subscribed"
            case community = "Community"
            
            var label: String {
                switch self {
                case .all: return "listing-all".localized
                case .local: return "listing-local".localized
                case .subscribed: return "listing-subscribed".localized
                case .community: return "listing-community".localized
                }
            }
        }
        
        enum SearchType: String, CaseIterable, Codable {
            case all = "All"
            case comments = "Comments"
            case posts = "Posts"
            case communities = "Communities"
            case users = "Users"
            case url = "Url"
            
            var label: String {
            switch self {
            case .all: return "searchtype-all".localized
            case .comments: return "searchtype-comments".localized
            case .posts: return "searchtype-posts".localized
            case .communities: return "searchtype-communities".localized
            case .users: return "searchtype-users".localized
            case .url: return "searchtype-url".localized
            }
            }
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
