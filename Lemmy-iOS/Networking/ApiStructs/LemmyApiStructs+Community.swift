//
//  LemmyApiStructs+Community.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/14/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

extension LemmyApiStructs {
    enum Community {
        
        // MARK: - ListCommunities
        struct ListCommunitiesRequest {
            let sort: LemmySortType
            let limit: Int
            let page: Int
            let auth: String?
        }
        
        struct ListCommunitiesResponse {
            let communities: Array<CommunityView>
        }
    }
}
