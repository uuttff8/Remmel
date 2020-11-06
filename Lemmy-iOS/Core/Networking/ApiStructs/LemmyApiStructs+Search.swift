//
//  LemmyApiStructs+Search.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 22.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

extension LemmyModel {
    enum Search {

        // MARK: - Search -
        struct SearchRequest: Codable, Equatable, Hashable {
            let query: String
            let type: LemmySearchSortType
            let communityId: Int?
            let communityName: String?
            let sort: LemmySortType
            let page: Int?
            let limit: Int?
            let auth: String?

            enum CodingKeys: String, CodingKey {
                case query = "q"
                case type = "type_"
                case communityId = "community_id"
                case communityName = "community_name"
                case sort, page, limit, auth
            }
        }

        struct SearchResponse: Codable, Equatable, Hashable {
            let type: LemmySortType
            let comments: [CommentView]
            let posts: [PostView]
            let communities: [CommunityView]
            let users: [UserView]

            enum CodingKeys: String, CodingKey {
                case type = "type_"
                case comments, posts, communities, users
            }
        }
    }
}
