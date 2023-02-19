//
//  LMModels+Api+Site.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 15.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

extension RMModels.Api {
    enum Site {
                
        /**
        * Search types are `All, Comments, Posts, Communities, Users, Url`
        */
        struct Search: Codable {
            let query: String
            let type: RMModels.Others.SearchType?
            let communityId: Int?
            let communityName: String?
            let creatorId: String?
            let sort: RMModels.Others.SortType?
            let listingType: RMModels.Others.ListingType?
            let page: Int?
            let limit: Int?
            let auth: String?
            
            enum CodingKeys: String, CodingKey {
                case query = "q"
                case type = "type_"
                case communityId = "community_id"
                case communityName = "community_name"
                case creatorId = "creator_id"
                case listingType = "listing_type"
                case sort, page, limit, auth
            }
        }
        
        struct SearchResponse: Codable {
            let type: RMModels.Others.SearchType
            let comments: [RMModels.Views.CommentView]
            let posts: [RMModels.Views.PostView]
            let communities: [RMModels.Views.CommunityView]
            let users: [RMModels.Views.PersonViewSafe]
            
            enum CodingKeys: String, CodingKey {
                case type = "type_"
                case comments, posts, communities, users
            }
        }
        
        struct GetModlog: Codable {
            let modPersonId: Int?
            let communityId: Int?
            let page: Int?
            let limit: Int?
            let auth: String?
            
            enum CodingKeys: String, CodingKey {
                case modPersonId = "mod_person_id"
                case communityId = "community_id"
                case page, limit, auth
            }
        }
        
        struct GetModlogResponse: Codable {
            let removedPosts: [RMModels.Views.ModRemovePostView]
            let lockedPosts: [RMModels.Views.ModLockPostView]
            let stickiedPosts: [RMModels.Views.ModStickyPostView]
            let removedComments: [RMModels.Views.ModRemoveCommentView]
            let removedCommunities: [RMModels.Views.ModRemoveCommunityView]
            let bannedFromCommunity: [RMModels.Views.ModBanFromCommunityView]
            let banned: [RMModels.Views.ModBanView]
            let addedToCommunity: [RMModels.Views.ModAddCommunityView]
            let transferredToCommunity: [RMModels.Views.ModTransferCommunityView]
            let added: [RMModels.Views.ModAddView]
            
            enum CodingKeys: String, CodingKey {
                case removedPosts = "removed_posts"
                case lockedPosts = "locked_posts"
                case stickiedPosts = "stickied_posts"
                case removedComments = "removed_comments"
                case removedCommunities = "removed_communities"
                case bannedFromCommunity = "banned_from_community"
                case banned
                case addedToCommunity = "added_to_community"
                case transferredToCommunity = "transferred_to_community"
                case added
            }
        }
        
        struct CreateSite: Codable {
            let name: String
            let sidebar: String?
            let description: String?
            let icon: String?
            let banner: String?
            let enableDownvotes: Bool?
            let openRegistration: Bool?
            let enableNsfw: Bool?
            let communityCreationAdminOnly: Bool?
            let requireEmailVerification: Bool?
            let requireApplication: Bool?
            let applicationQuestion: Bool?
            let privateInstance: Bool?
            let defaultTheme: String?
            let defaultPostListingType: String?
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case name, description, icon, banner, sidebar
                case enableDownvotes = "enable_downvotes"
                case openRegistration = "open_registration"
                case enableNsfw = "enable_nsfw"
                case communityCreationAdminOnly = "community_creation_admin_only"
                case requireEmailVerification = "require_email_verification"
                case requireApplication = "require_application"
                case applicationQuestion = "application_question"
                case privateInstance = "private_instance"
                case defaultTheme = "default_theme"
                case defaultPostListingType = "default_post_listing_type"
                case auth
            }
        }
        
        struct EditSite: Codable {
            let name: String?
            let sidebar: String?
            let description: String?
            let icon: String?
            let banner: String?
            let enableDownvotes: Bool?
            let openRegistration: Bool?
            let enableNsfw: Bool?
            let communityCreationAdminOnly: Bool?
            let requireEmailVerification: Bool?
            let requireApplication: Bool?
            let applicationQuestion: Bool?
            let privateInstance: Bool?
            let defaultTheme: String?
            let legalInformation: String?
            let defaultPostListingType: String?
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case name, description, icon, banner, sidebar
                case enableDownvotes = "enable_downvotes"
                case openRegistration = "open_registration"
                case enableNsfw = "enable_nsfw"
                case communityCreationAdminOnly = "community_creation_admin_only"
                case requireEmailVerification = "require_email_verification"
                case requireApplication = "require_application"
                case applicationQuestion = "application_question"
                case privateInstance = "private_instance"
                case defaultTheme = "default_theme"
                case legalInformation = "legal_information"
                case defaultPostListingType = "default_post_listing_type"
                case auth
            }
        }
        
        struct GetSite: Codable {
            let auth: String?
        }
        
        struct SiteResponse: Codable {
            let siteView: RMModels.Views.SiteView
            
            enum CodingKeys: String, CodingKey {
                case siteView = "site_view"
            }
        }
        
        struct GetSiteResponse: Codable {
            let siteView: RMModels.Views.SiteView? // Optional, Because the site might not be set up yet.
            let admins: [RMModels.Views.PersonViewSafe]
            let online: Int
            let version: String
            let myUser: MyUserInfo? // If you're logged in, you'll get back extra user info.
            let federatedInstances: FederatedInstances?
            
            enum CodingKeys: String, CodingKey {
                case siteView = "site_view"
                case admins, online, version
                case myUser = "my_user"
                case federatedInstances = "federated_instances"
            }
        }
        
        /**
        * Your user info, such as blocks, follows, etc.
        */
        struct MyUserInfo: Codable {
            let localUserView: RMModels.Views.LocalUserSettingsView
            let follows: [RMModels.Views.CommunityFollowerView]
            let moderates: [RMModels.Views.CommunityModeratorView]
            let communityBlocks: [RMModels.Views.CommunityBlockView]
            let personBlocks: [RMModels.Views.PersonBlockView]
            
            enum CodingKeys: String, CodingKey {
                case localUserView = "local_user_view"
                case follows, moderates
                case communityBlocks = "community_blocks"
                case personBlocks = "person_blocks"
            }

       }

        struct LeaveAdmin: Codable {
            let auth: String
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
                
        struct FederatedInstances: Codable {
            let linked: [String]
            let allowed: [String]?
            let blocked: [String]?
         }
        
        struct ResolveObject: Codable {
            let q: String
            let auth: String?
       }

        struct ResolveObjectResponse: Codable {
           let comment: RMModels.Views.CommentView?
           let post: RMModels.Views.PostView?
           let community: RMModels.Views.CommunityView?
           let person: RMModels.Views.PersonViewSafe?
        }
        
        struct ListRegistrationApplications: Codable {
          /**
           * Only shows the unread applications (IE those without an admin actor)
           */
            let unreadOnly: Bool?
            let page: Int?
            let limit: Int?
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case unreadOnly = "unread_only"
                case page
                case limit
                case auth
            }
        }

        struct ListRegistrationApplicationsResponse: Codable {
            let registrationApplications: [RMModels.Views.RegistrationApplicationView]
            
            enum CodingKeys: String, CodingKey {
                case registrationApplications = "registration_applications"
            }
        }
        
        struct ApproveRegistrationApplication {
            let id: Int
            let approve: Bool
            let deny_reason: String?
            let auth: String
        }
        
        struct RegistrationApplicationResponse: Codable {
            let registrationApplications: RMModels.Views.RegistrationApplicationView
            
            enum CodingKeys: String, CodingKey {
                case registrationApplications = "registration_applications"
            }
        }
        
        struct GetUnreadRegistrationApplicationCount {
            let auth: String
        }
        
        struct GetUnreadRegistrationApplicationCountResponse: Codable {
            let registrationApplications: Int
            
            enum CodingKeys: String, CodingKey {
                case registrationApplications = "registration_applications"
            }
        }
    }
}
