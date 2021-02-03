//
//  LMModels+Api+Site.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 15.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

extension LMModels.Api {
    enum Site {
        
        struct ListCategories: Codable {}
        
        struct ListCategoriesResponse: Codable {
            let categories: [LMModels.Source.Category]
        }
        
        /**
        * Search types are `All, Comments, Posts, Communities, Users, Url`
        */
        struct Search: Codable {
            let query: String
            let type: LMModels.Others.SearchType
            let communityId: Int?
            let communityName: String?
            let sort: LMModels.Others.SortType
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
        
        struct SearchResponse: Codable {
            let type: LMModels.Others.SearchType
            let comments: [LMModels.Views.CommentView]
            let posts: [LMModels.Views.PostView]
            let communities: [LMModels.Views.CommunityView]
            let users: [LMModels.Views.UserViewSafe]
            
            enum CodingKeys: String, CodingKey {
                case type = "type_"
                case comments, posts, communities, users
            }
        }
        
        struct GetModlog: Codable {
            let modUserId: Int?
            let communityId: Int?
            let page: Int?
            let limit: Int?
            
            enum CodingKeys: String, CodingKey {
                case modUserId = "mod_user_id"
                case communityId = "community_id"
                case page, limit
            }
        }
        
        struct GetModlogResponse: Codable {
            let removedPosts: [LMModels.Views.ModRemovePostView]
            let lockedPosts: [LMModels.Views.ModLockPostView]
            let stickiedPosts: [LMModels.Views.ModStickyPostView]
            let removedComments: [LMModels.Views.ModRemoveCommentView]
            let removedCommunities: [LMModels.Views.ModRemoveCommunityView]
            let bannedFromCommunity: [LMModels.Views.ModBanFromCommunityView]
            let banned: [LMModels.Views.ModBanView]
            let addedToCommunity: [LMModels.Views.ModAddCommunityView]
            let added: [LMModels.Views.ModAddView]
            
            enum CodingKeys: String, CodingKey {
                case removedPosts = "removed_posts"
                case lockedPosts = "locked_posts"
                case stickiedPosts = "stickied_posts"
                case removedComments = "removed_comments"
                case removedCommunities = "removed_communities"
                case bannedFromCommunity = "banned_from_community"
                case banned
                case addedToCommunity = "added_to_community"
                case added
            }
        }
        
        struct CreateSite: Codable {
            let name: String
            let description: String?
            let icon: String?
            let banner: String
            let enableDownvotes: Bool
            let openRegistration: Bool
            let enableNsfw: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case name, description, icon, banner
                case enableDownvotes = "enable_downvotes"
                case openRegistration = "open_registration"
                case enableNsfw = "enable_nsfw"
                case auth
            }
        }
        
        struct EditSite: Codable {
            let name: String
            let description: String
            let icon: String
            let banner: String
            let enableDownvotes: Bool
            let openRegistration: Bool
            let enableNsfw: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case name, description, icon, banner
                case enableDownvotes = "enable_downvotes"
                case openRegistration = "open_registration"
                case enableNsfw = "enable_nsfw"
                case auth
            }
        }
        
        struct GetSite: Codable {
            let auth: String?
        }
        
        struct SiteResponse: Codable {
            let siteView: LMModels.Views.SiteView
            
            enum CodingKeys: String, CodingKey {
                case siteView = "site_view"
            }
        }
        
        struct GetSiteResponse: Codable {
            let siteView: LMModels.Views.SiteView? // Because the site might not be set up y,
            let admins: [LMModels.Views.UserViewSafe]
            let banned: [LMModels.Views.UserViewSafe]
            let online: Int
            let version: String
            let myUser: LMModels.Source.UserSafeSettings? // Gives back your user and settings if logged
            let federatedInstances: FederatedInstances?
            
            enum CodingKeys: String, CodingKey {
                case siteView = "site_view"
                case admins, banned, online, version
                case myUser = "my_user"
                case federatedInstances = "federated_instances"
            }
        }
        
        struct TransferSite: Codable {
            let userId: Int
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case userId = "user_id"
                case auth
            }
        }
        
        struct FederatedInstances: Codable {
            let linked: [String]
            let allowed: [String]
            let blocked: [String]
         }
        
        struct GetSiteConfig: Codable {
            let auth: String
        }
        
        struct GetSiteConfigResponse: Codable {
            let configHJson: String
            
            enum CodingKeys: String, CodingKey {
                case configHJson = "config_hjson"
            }
        }
        
        struct SaveSiteConfig: Codable {
            let configHJson: String
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case configHJson = "config_hjson"
                case auth
            }
        }
                
    }
}
