//
//  enums.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

enum PostType {
    case image
    case video
    case `default`
    case none
    
    static func getPostType(from post: LemmyModel.PostView) -> PostType {
        guard let url = post.url,
              !url.isEmpty
        else { return PostType.none }
        
        if url.hasSuffix("jpg")
            || url.hasSuffix(".jpeg")
            || url.hasSuffix(".png")
            || url.hasSuffix(".gif")
            || url.hasSuffix(".webp")
            || url.hasSuffix(".bmp")
            || url.hasSuffix(".wbpm") {
            
            return PostType.image
        }
        
        return PostType.default
    }
}

enum LemmyVoteType: Int, Codable {
    case none = 0
    case up = 1
    case down = -1
}

enum LemmySortType: String, Codable, CaseIterable, LemmyTypePickable {
    case active = "Active"
    case hot = "Hot"
    case new = "New"

    case topDay = "TopDay"
    case topWeek = "TopWeek"
    case topMonth = "TopMonth"
    case topYear = "TopYear"

    case topAll = "TopAll"
    
    case all = "All"
    
    // all is not included in sorting FronPage
    static var reallySort: [LemmySortType] {
        [.active, .hot, .new, topDay, topWeek, topMonth, .topYear, .topAll]
    }

    var label: String {
        switch self {
        case .active: return "Active"
        case .hot: return "Hot"
        case .new: return "New"
        case .topDay: return "Top Day"
        case .topWeek: return "Top Week"
        case .topMonth: return "Top Month"
        case .topAll: return "Top All"
        case .topYear: return "Top Year"
        case .all: return "All"
        }
    }

    var index: Int {
        switch self {
        case .active: return 0
        case .hot: return 1
        case .new: return 2
        case .topDay: return 3
        case .topWeek: return 4
        case .topMonth: return 5
        case .topYear: return 6
        case .topAll: return 7
        case .all: return 8
        }
    }
}

enum LemmySearchSortType: String, Codable {
    case all = "All"
    case comments = "Comments"
    case posts = "Posts"
    case communities = "Communities"
    case users = "Users"
    case url = "Url"
    
    static var searchViewConfig: [LemmySearchSortType] {
        [.comments, .posts, .communities, .users]
    }
}

enum LemmyPostListingType: String, Codable, CaseIterable {
    case all = "All"
    case subscribed = "Subscribed"
    case community = "Community"
    
    var index: Int {
        switch self {
        case .all: return 0
        case .subscribed: return 1
        case .community: return 2
        }
    }
    
    var label: String {
        switch self {
        case .community: return "Community"
        case .all: return "All"
        case .subscribed: return "Subscribed"
        }
    }
}

enum LemmyContentType: String, Codable, CaseIterable {
    case posts = "Posts"
    case comments = "Comments"

    var label: String {
        switch self {
        case .posts: return "Posts"
        case .comments: return "Comments"
        }
    }

    var index: Int {
        switch self {
        case .posts: return 0
        case .comments: return 1
        }
    }
}
