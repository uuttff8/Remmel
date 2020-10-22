//
//  LemmyApiStructs+Search.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 22.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

extension LemmyApiStructs {
    enum Search {
        
        // MARK: - Search -
        struct SearchRequest: Codable, Equatable, Hashable {
            let q: String
            let type_: LemmySearchType
            let community_id: Int?
            let community_name: String?
            let sort: LemmySortType
            let page: Int?
            let limit: Int?
            let auth: String?
        }
        
        struct SearchResponse: Codable, Equatable, Hashable {
            let type_: LemmySearchType
            let comments: Array<CommentView>
            let posts: Array<PostView>
            let communities: Array<CommunityView>
            let users: Array<UserView>
        }
    }
}
