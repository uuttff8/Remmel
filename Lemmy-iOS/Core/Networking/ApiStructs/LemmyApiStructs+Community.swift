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
        struct ListCommunitiesRequest: Codable, Equatable {
            let sort: LemmySortType
            let limit: Int?
            let page: Int?
            let auth: String?
        }
        
        struct ListCommunitiesResponse: Codable, Equatable {
            let communities: Array<CommunityView>
        }
        
        // MARK: - CreateCommunity -
        struct CreateCommunityRequest: Codable, Equatable, Hashable {
            let name: String
            let title: String
            let description: String?
            let icon: String?
            let banner: String?
            let categoryId: Int
            let nsfw: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case name, title, description, icon, banner
                case categoryId = "category_id"
                case nsfw, auth
            }
        }
        
        struct CreateCommunityResponse: Codable, Equatable, Hashable {
            let community: CommunityView
        }
    }
}
