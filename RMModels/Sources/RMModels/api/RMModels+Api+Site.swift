//
//  RMModels+Api+Site.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 15.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

public extension RMModels.Api {
    enum Site {
                
        /**
        * Search types are `All, Comments, Posts, Communities, Users, Url`
        */
        public struct Search: Codable {
            public let query: String
            public let type: RMModels.Others.SearchType?
            public let communityId: Int?
            public let communityName: String?
            public let creatorId: String?
            public let sort: RMModels.Others.SortType?
            public let listingType: RMModels.Others.ListingType?
            public let page: Int?
            public let limit: Int?
            public let auth: String?
            
            public init(query: String, type: RMModels.Others.SearchType?, communityId: Int?, communityName: String?, creatorId: String?, sort: RMModels.Others.SortType?, listingType: RMModels.Others.ListingType?, page: Int?, limit: Int?, auth: String?) {
                self.query = query
                self.type = type
                self.communityId = communityId
                self.communityName = communityName
                self.creatorId = creatorId
                self.sort = sort
                self.listingType = listingType
                self.page = page
                self.limit = limit
                self.auth = auth
            }
            
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
        
        public struct SearchResponse: Codable {
            public let type: RMModels.Others.SearchType
            public let comments: [RMModels.Views.CommentView]
            public let posts: [RMModels.Views.PostView]
            public let communities: [RMModels.Views.CommunityView]
            public let users: [RMModels.Views.PersonViewSafe]
            
            enum CodingKeys: String, CodingKey {
                case type = "type_"
                case comments, posts, communities, users
            }
        }
        
        public struct GetModlog: Codable {
            public let modPersonId: Int?
            public let communityId: Int?
            public let page: Int?
            public let limit: Int?
            public let auth: String?
            
            enum CodingKeys: String, CodingKey {
                case modPersonId = "mod_person_id"
                case communityId = "community_id"
                case page, limit, auth
            }
        }
        
        public struct GetModlogResponse: Codable {
            public let removedPosts: [RMModels.Views.ModRemovePostView]
            public let lockedPosts: [RMModels.Views.ModLockPostView]
            public let featuredPosts: [RMModels.Views.ModFeaturePostView]
            public let removedComments: [RMModels.Views.ModRemoveCommentView]
            public let removedCommunities: [RMModels.Views.ModRemoveCommunityView]
            public let bannedFromCommunity: [RMModels.Views.ModBanFromCommunityView]
            public let banned: [RMModels.Views.ModBanView]
            public let addedToCommunity: [RMModels.Views.ModAddCommunityView]
            public let transferredToCommunity: [RMModels.Views.ModTransferCommunityView]
            public let added: [RMModels.Views.ModAddView]
            
            enum CodingKeys: String, CodingKey {
                case removedPosts = "removed_posts"
                case lockedPosts = "locked_posts"
                case featuredPosts = "featured_posts"
                case removedComments = "removed_comments"
                case removedCommunities = "removed_communities"
                case bannedFromCommunity = "banned_from_community"
                case banned
                case addedToCommunity = "added_to_community"
                case transferredToCommunity = "transferred_to_community"
                case added
            }
        }
        
        public struct CreateSite: Codable {
            public let name: String
            public let sidebar: String?
            public let description: String?
            public let icon: String?
            public let banner: String?
            public let enableDownvotes: Bool?
            public let openRegistration: Bool?
            public let enableNsfw: Bool?
            public let communityCreationAdminOnly: Bool?
            public let requireEmailVerification: Bool?
            public let registrationMode: RMModels.Source.RegistrationMode?
            public let applicationQuestion: Bool?
            public let privateInstance: Bool?
            public let defaultTheme: String?
            public let defaultPostListingType: String?
            public let auth: String
            
            enum CodingKeys: String, CodingKey {
                case name, description, icon, banner, sidebar
                case enableDownvotes = "enable_downvotes"
                case openRegistration = "open_registration"
                case enableNsfw = "enable_nsfw"
                case communityCreationAdminOnly = "community_creation_admin_only"
                case requireEmailVerification = "require_email_verification"
                case registrationMode = "registration_mode"
                case applicationQuestion = "application_question"
                case privateInstance = "private_instance"
                case defaultTheme = "default_theme"
                case defaultPostListingType = "default_post_listing_type"
                case auth
            }
        }
        
        public struct EditSite: Codable {
            public let name: String?
            public let sidebar: String?
            public let description: String?
            public let icon: String?
            public let banner: String?
            public let enableDownvotes: Bool?
            public let openRegistration: Bool?
            public let enableNsfw: Bool?
            public let communityCreationAdminOnly: Bool?
            public let requireEmailVerification: Bool?
            public let requireApplication: Bool?
            public let applicationQuestion: Bool?
            public let privateInstance: Bool?
            public let defaultTheme: String?
            public let legalInformation: String?
            public let defaultPostListingType: String?
            public let auth: String
            
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
        
        public struct GetSite: Codable {
            public let auth: String?
            
            public init(auth: String?) {
                self.auth = auth
            }
        }
        
        public struct SiteResponse: Codable {
            public let siteView: RMModels.Views.SiteView
            
            enum CodingKeys: String, CodingKey {
                case siteView = "site_view"
            }
        }
        
        public struct GetSiteResponse: Codable {
            public let siteView: RMModels.Views.SiteView
            public let admins: [RMModels.Views.PersonViewSafe]
            public let online: Int
            public let version: String
            public let myUser: MyUserInfo? // If you're logged in, you'll get back extra user info.
            public let federatedInstances: FederatedInstances?
            public let allLanguages: [RMModels.Source.Language]
            public let discussionLanguages: [Int]
            public let taglines: [RMModels.Source.Tagline]?
            
            enum CodingKeys: String, CodingKey {
                case siteView = "site_view"
                case admins, online, version
                case myUser = "my_user"
                case federatedInstances = "federated_instances"
                case allLanguages = "all_languages"
                case discussionLanguages = "discussion_languages"
                case taglines
            }
        }
        
        /**
        * Your user info, such as blocks, follows, etc.
        */
        public struct MyUserInfo: Codable {
            public let localUserView: RMModels.Views.LocalUserSettingsView
            public let follows: [RMModels.Views.CommunityFollowerView]
            public let moderates: [RMModels.Views.CommunityModeratorView]
            public let communityBlocks: [RMModels.Views.CommunityBlockView]
            public let personBlocks: [RMModels.Views.PersonBlockView]
            public let discussionLanguages: [Int]
            
            enum CodingKeys: String, CodingKey {
                case localUserView = "local_user_view"
                case follows, moderates
                case communityBlocks = "community_blocks"
                case personBlocks = "person_blocks"
                case discussionLanguages = "discussion_languages"
            }

       }

        public struct LeaveAdmin: Codable {
            public let auth: String
        }
                
        public struct FederatedInstances: Codable {
            public let linked: [String]
            public let allowed: [String]?
            public let blocked: [String]?
         }
        
        public struct ResolveObject: Codable {
            public let q: String
            public let auth: String?
       }

        public struct ResolveObjectResponse: Codable {
            public let comment: RMModels.Views.CommentView?
            public let post: RMModels.Views.PostView?
            public let community: RMModels.Views.CommunityView?
            public let person: RMModels.Views.PersonViewSafe?
        }
        
        public struct PurgePerson {
            public let personId: Int
            public let reason: String?
            public let auth: String
            
            enum CodingKeys: String, CodingKey {
                case personId = "person_id"
                case reason, auth
            }
        }
        
        public struct PurgeCommunity {
            public let communityId: Int
            public let reason: String?
            public let auth: String
            
            enum CodingKeys: String, CodingKey {
                case communityId = "community_id"
                case reason, auth
            }
        }
        
        public struct PurgePost {
            public let postId: Int
            public let reason: String?
            public let auth: String
            
            enum CodingKeys: String, CodingKey {
                case postId = "post_id"
                case reason, auth
            }
        }
        
        public struct PurgeComment {
            public let commentId: Int
            public let reason: String?
            public let auth: String
            
            enum CodingKeys: String, CodingKey {
                case commentId = "comment_id"
                case reason, auth
            }
        }
        
        public struct PurgeItemResponse {
            public let success: Bool
        }
        
        public struct ListRegistrationApplications: Codable {
          /**
           * Only shows the unread applications (IE those without an admin actor)
           */
            public let unreadOnly: Bool?
            public let page: Int?
            public let limit: Int?
            public let auth: String
            
            enum CodingKeys: String, CodingKey {
                case unreadOnly = "unread_only"
                case page
                case limit
                case auth
            }
        }

        public struct ListRegistrationApplicationsResponse: Codable {
            public let registrationApplications: [RMModels.Views.RegistrationApplicationView]
            
            enum CodingKeys: String, CodingKey {
                case registrationApplications = "registration_applications"
            }
        }
        
        public struct ApproveRegistrationApplication {
            public let id: Int
            public let approve: Bool
            public let deny_reason: String?
            public let auth: String
        }
        
        public struct RegistrationApplicationResponse: Codable {
            public let registrationApplications: RMModels.Views.RegistrationApplicationView
            
            enum CodingKeys: String, CodingKey {
                case registrationApplications = "registration_applications"
            }
        }
        
        public struct GetUnreadRegistrationApplicationCount {
            public let auth: String
        }
        
        public struct GetUnreadRegistrationApplicationCountResponse: Codable {
            public let registrationApplications: Int
            
            enum CodingKeys: String, CodingKey {
                case registrationApplications = "registration_applications"
            }
        }
    }
}
