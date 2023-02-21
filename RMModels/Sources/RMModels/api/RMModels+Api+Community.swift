//
//  RMModels+Api+Community.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 15.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

public extension RMModels.Api {
    enum Community {
        
        public struct GetCommunity: Codable {
            public let id: Int?
            public let name: String?
            public let auth: String?
            
            public init(id: Int?, name: String?, auth: String?) {
                self.id = id
                self.name = name
                self.auth = auth
            }
        }
        
        public struct GetCommunityResponse: Codable {
            public let communityView: RMModels.Views.CommunityView
            public let site: RMModels.Source.Site?
            public let moderators: [RMModels.Views.CommunityModeratorView]
            public let online: Int
            public let discussionLanguages: [Int]
            public let defaultPostLanguage: Int?
            
            enum CodingKeys: String, CodingKey {
                case communityView = "community_view"
                case site, moderators, online
                case discussionLanguages = "discussion_languages"
                case defaultPostLanguage = "default_post_language"
            }
        }
        
        public struct CreateCommunity: Codable {
            public let name: String
            public let title: String
            public let description: String?
            public let icon: String?
            public let banner: String?
            public let nsfw: Bool?
            public let postingRestrictedToMods: Bool?
            public let discussionLanguages: [Int]?
            public let auth: String
            
            public init(name: String, title: String, description: String?, icon: String?, banner: String?, nsfw: Bool?, postingRestrictedToMods: Bool?, discussionLanguages: [Int]?, auth: String) {
                self.name = name
                self.title = title
                self.description = description
                self.icon = icon
                self.banner = banner
                self.nsfw = nsfw
                self.postingRestrictedToMods = postingRestrictedToMods
                self.discussionLanguages = discussionLanguages
                self.auth = auth
            }
            
            enum CodingKeys: String, CodingKey {
                case name, title, description, icon, banner
                case postingRestrictedToMods = "posting_restricted_to_mods"
                case discussionLanguages = "discussion_languages"
                case nsfw, auth
            }
        }
        
        public struct CommunityResponse: Codable {
            public let communityView: RMModels.Views.CommunityView
            
            enum CodingKeys: String, CodingKey {
                case communityView = "community_view"
            }
        }
        
        public struct ListCommunities: Codable {
            public let type: RMModels.Others.ListingType?
            public let sort: RMModels.Others.SortType?
            public let page: Int?
            public let limit: Int?
            public let auth: String?
            
            public init(type: RMModels.Others.ListingType?, sort: RMModels.Others.SortType?, page: Int?, limit: Int?, auth: String?) {
                self.type = type
                self.sort = sort
                self.page = page
                self.limit = limit
                self.auth = auth
            }
            
            enum CodingKeys: String, CodingKey {
                case type = "type_"
                case sort, page, limit, auth
            }
        }
        
        public struct ListCommunitiesResponse: Codable {
            public let communities: [RMModels.Views.CommunityView]
        }
        
        public struct BanFromCommunity: Codable {
            public let communityId: Int
            public let personId: Int
            public let ban: Bool
            public let removeData: Bool? // Removes/Restores their comments and posts for that community
            public let reason: String?
            public let expires: Int?
            public let auth: String
            
            enum CodingKeys: String, CodingKey {
                case communityId = "community_id"
                case personId = "person_id"
                case ban
                case removeData = "remove_data"
                case reason, expires, auth
            }
        }
        
        public struct BanFromCommunityResponse: Codable {
            public let personView: RMModels.Views.PersonViewSafe
            public let banned: Bool
            
            enum CodingKeys: String, CodingKey {
                case personView = "person_view"
                case banned
            }
        }
        
        public struct AddModToCommunity: Codable {
            public let communityId: Int
            public let personId: Int
            public let added: Bool
            public let auth: String
            
            enum CodingKeys: String, CodingKey {
                case communityId = "community_id"
                case personId = "person_id"
                case added, auth
            }
        }
        
        public struct AddModToCommunityResponse: Codable {
            public let moderators: [RMModels.Views.CommunityModeratorView]
        }
        
        /**
        * Only mods can edit a community.
        */
        public struct EditCommunity: Codable {
            public let communityId: Int
            public let title: String?
            public let description: String?
            public let icon: String?
            public let banner: String?
            public let nsfw: Bool?
            public let postingRestrictedToMods: Bool?
            public let discussionLanguages: [Int]?
            public let auth: String
            
            enum CodingKeys: String, CodingKey {
                case communityId = "community_id"
                case title, description, icon, banner, nsfw
                case postingRestrictedToMods = "posting_restricted_to_mods"
                case discussionLanguages = "discussion_languages"
                case auth
            }
        }
        
        public struct DeleteCommunity: Codable {
            public let communityId: Int
            public let deleted: Bool
            public let auth: String
            
            enum CodingKeys: String, CodingKey {
                case communityId = "community_id"
                case deleted, auth
            }
        }
        
        public struct RemoveCommunity: Codable {
            public let communityId: Int
            public let removed: Bool
            public let reason: String?
            public let expires: Int? /// The expire time in Unix seconds
            public let auth: String
            
            enum CodingKeys: String, CodingKey {
                case communityId = "community_id"
                case removed, reason, expires, auth
            }
        }
        
        public struct FollowCommunity: Codable {
            public let communityId: Int
            public let follow: Bool
            public let auth: String
            
            public init(communityId: Int, follow: Bool, auth: String) {
                self.communityId = communityId
                self.follow = follow
                self.auth = auth
            }
            
            enum CodingKeys: String, CodingKey {
                case communityId = "community_id"
                case follow, auth
            }
        }
                
        public struct TransferCommunity: Codable {
            public let communityId: Int
            public let personId: Int
            public let auth: String
            
            enum CodingKeys: String, CodingKey {
                case communityId = "community_id"
                case personId = "person_id"
                case auth
            }
        }

        public struct BlockCommunity: Codable {
            public let communityId: Int
            public let block: Bool
            public let auth: String

            enum CodingKeys: String, CodingKey {
                case communityId = "community_id"
                case block, auth
            }
        }

        public struct BlockCommunityResponse: Codable {
            public let communityView: RMModels.Views.CommunityView
            public let blocked: Bool

            enum CodingKeys: String, CodingKey {
                case communityView = "community_view"
                case blocked
            }
        }
    }
}
