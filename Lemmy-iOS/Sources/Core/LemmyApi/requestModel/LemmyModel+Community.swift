//
//  LemmyApiStructs+Community.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/14/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

extension LemmyModel {
    enum Community {

        // MARK: - ListCommunities
        struct ListCommunitiesRequest: Codable, Equatable {
            let sort: LemmySortType
            let limit: Int?
            let page: Int?
            let auth: String?
        }

        struct ListCommunitiesResponse: Codable, Equatable {
            let communities: [CommunityView]
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
        
        // MARK: - GetCommunity -
        struct GetCommunityRequest: Codable, Equatable, Hashable {
            let id: Int?
            let name: String?
            let auth: String?
        }
        
        struct GetCommunityResponse: Codable, Equatable, Hashable {
            let community: CommunityView
            let moderators: [CommunityModeratorView]
        }
        
        // MARK: - FollowCommunity -
        struct FollowCommunityRequest: Codable, Equatable, Hashable {
            let communityId: Int
            let follow: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case communityId = "community_id"
                case follow, auth
            }
        }
        
        struct FollowCommunityResponse: Codable, Equatable, Hashable {
            let community: CommunityView
        }
        
        // MARK: - RemoveCommunity -
        // Only admins can remove a community.
        struct RemoveCommunityRequest: Codable, Equatable, Hashable {
            let editId: Int
            let removed: Bool
            let reason: String?
            let expires: Int?
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case editId = "edit_id"
                case removed, reason, expires, auth
            }
        }
        
        struct RemoveCommunityResponse: Codable, Equatable, Hashable {
            let community: CommunityView
        }
        
        // MARK: - DeleteCommunity -
        struct DeleteCommunityRequest: Codable, Equatable, Hashable {
            let editId: Int
            let deleted: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case editId = "edit_id"
                case deleted, auth
            }
        }
        
        struct DeleteCommunityResponse: Codable, Equatable, Hashable {
            let community: CommunityView
        }
        
        // MARK: - BanFromCommunity -
        struct BanFromCommunityRequest: Codable, Equatable, Hashable {
            let userId: Int
            let communityId: Int
            let ban: Bool
            let removeData: Bool? // Removes/Restores their comments and posts for that community
            let reason: String?
            let expires: Int?
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case userId = "user_id"
                case communityId = "community_id"
                case ban
                case removeData = "remove_data"
                case reason, expires, auth
            }
        }
        
        struct BanFromCommunityResponse: Codable, Equatable, Hashable {
            let user: UserView
            let banned: Bool
        }
        
        // MARK: - AddModToCommunity -
        struct AddModToCommunityRequest: Codable, Equatable, Hashable {
            let community_id: Int
            let user_id: Int
            let added: Bool
            let auth: String
        }
        
        struct AddModToCommunityResponse: Codable, Equatable, Hashable {
            let moderators: [CommunityModeratorView]
        }
        
    }
}
