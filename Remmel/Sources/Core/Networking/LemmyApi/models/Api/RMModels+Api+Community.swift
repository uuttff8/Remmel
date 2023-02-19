//
//  LMModels+Api+Community.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 15.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

extension RMModels.Api {
    enum Community {
        
        struct GetCommunity: Codable {
            let id: Int?
            let name: String?
            let auth: String?
        }
        
        struct GetCommunityResponse: Codable {
            let communityView: RMModels.Views.CommunityView
            let site: RMModels.Source.Site?
            let moderators: [RMModels.Views.CommunityModeratorView]
            let online: Int
            
            enum CodingKeys: String, CodingKey {
                case communityView = "community_view"
                case site, moderators, online
            }
        }
        
        struct CreateCommunity: Codable {
            let name: String
            let title: String
            let description: String?
            let icon: String?
            let banner: String?
            let nsfw: Bool?
            let postingRestrictedToMods: Bool?
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case name, title, description, icon, banner
                case postingRestrictedToMods = "posting_restricted_to_mods"
                case nsfw, auth
            }
        }
        
        struct CommunityResponse: Codable {
            let communityView: RMModels.Views.CommunityView
            
            enum CodingKeys: String, CodingKey {
                case communityView = "community_view"
            }
        }
        
        struct ListCommunities: Codable {
            let type: RMModels.Others.ListingType?
            let sort: RMModels.Others.SortType?
            let page: Int?
            let limit: Int?
            let auth: String?
            
            enum CodingKeys: String, CodingKey {
                case type = "type_"
                case sort, page, limit, auth
            }
        }
        
        struct ListCommunitiesResponse: Codable {
            let communities: [RMModels.Views.CommunityView]
        }
        
        struct BanFromCommunity: Codable {
            let communityId: Int
            let personId: Int
            let ban: Bool
            let removeData: Bool? // Removes/Restores their comments and posts for that community
            let reason: String?
            let expires: Int?
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case communityId = "community_id"
                case personId = "person_id"
                case ban
                case removeData = "remove_data"
                case reason, expires, auth
            }
        }
        
        struct BanFromCommunityResponse: Codable {
            let personView: RMModels.Views.PersonViewSafe
            let banned: Bool
            
            enum CodingKeys: String, CodingKey {
                case personView = "person_view"
                case banned
            }
        }
        
        struct AddModToCommunity: Codable {
            let communityId: Int
            let personId: Int
            let added: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case communityId = "community_id"
                case personId = "person_id"
                case added, auth
            }
        }
        
        struct AddModToCommunityResponse: Codable {
            let moderators: [RMModels.Views.CommunityModeratorView]
        }
        
        /**
        * Only mods can edit a community.
        */
        struct EditCommunity: Codable {
            let communityId: Int
            let title: String?
            let description: String?
            let icon: String?
            let banner: String?
            let nsfw: Bool?
            let postingRestrictedToMods: Bool?
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case communityId = "community_id"
                case title, description, icon, banner, nsfw
                case postingRestrictedToMods = "posting_restricted_to_mods"
                case auth
            }
        }
        
        struct DeleteCommunity: Codable {
            let communityId: Int
            let deleted: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case communityId = "community_id"
                case deleted, auth
            }
        }
        
        struct RemoveCommunity: Codable {
            let communityId: Int
            let removed: Bool
            let reason: String?
            let expires: Int? /// The expire time in Unix seconds
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case communityId = "community_id"
                case removed, reason, expires, auth
            }
        }
        
        struct FollowCommunity: Codable {
            let communityId: Int
            let follow: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case communityId = "community_id"
                case follow, auth
            }
        }
                
        struct TransferCommunity: Codable {
            let communityId: Int
            let personId: Int
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case communityId = "community_id"
                case personId = "person_id"
                case auth
            }
        }

        struct BlockCommunity: Codable {
            let communityId: Int
            let block: Bool
            let auth: String

            enum CodingKeys: String, CodingKey {
                case communityId = "community_id"
                case block, auth
            }
        }

        struct BlockCommunityResponse: Codable {
            let communityView: RMModels.Views.CommunityView
            let blocked: Bool

            enum CodingKeys: String, CodingKey {
                case communityView = "community_view"
                case blocked
            }
        }
    }
}
