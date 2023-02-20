//
//  RMModels+Api+Post.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 15.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

extension RMModels.Api {
    enum Post {
        
        struct CreatePost: Codable {
            let name: String
            let url: String?
            let body: String?
            let nsfw: Bool?
            let languageId: Int?
            let communityId: Int
            let honeypot: String?
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case name, url, body, nsfw
                case languageId = "language_id"
                case communityId = "community_id"
                case honeypot
                case auth
            }
        }
        
        struct PostResponse: Codable {
            let postView: RMModels.Views.PostView
            
            enum CodingKeys: String, CodingKey {
                case postView = "post_view"
            }
        }
        
        struct GetPost: Codable {
            let id: Int?
            let commentId: Int?
            let auth: String?
            
            enum CodingKeys: String, CodingKey {
                case id
                case commentId = "comment_id"
                case auth
            }
        }
        
        struct GetPostResponse: Codable {
            let postView: RMModels.Views.PostView
            let communityView: RMModels.Views.CommunityView
            let moderators: [RMModels.Views.CommunityModeratorView]
            let online: Int
            
            enum CodingKeys: String, CodingKey {
                case postView = "post_view"
                case communityView = "community_view"
                case moderators, online
            }
        }
        
        /**
        * Post listing types are `All, Subscribed, Community`
        *
        * `community_name` can only be used for local communities.
        * To get posts for a federated community, pass `community_id` instead.
        */
        struct GetPosts: Codable {
            let type: RMModels.Others.ListingType?
            let sort: RMModels.Others.SortType?
            let page: Int?
            let limit: Int?
            let communityId: Int?
            let communityName: String? // To get posts for a federated community by name, use `name@instance.tld` .
            let savedOnly: Bool?
            let auth: String?
            
            enum CodingKeys: String, CodingKey {
                case type = "type_"
                case sort, page, limit
                case communityId = "community_id"
                case communityName = "community_name"
                case auth
                case savedOnly = "saved_only"
            }
        }
        
        struct GetPostsResponse: Codable {
            let posts: [RMModels.Views.PostView]
        }
        
        /**
        * `score` can be 0, -1, or 1. Anything else will be rejected.
        */
        struct CreatePostLike: Codable {
            let postId: Int
            let score: Int
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case postId = "post_id"
                case score, auth
            }
        }
        
        struct EditPost: Codable {
            let postId: Int
            let name: String?
            let url: String?
            let body: String?
            let nsfw: Bool?
            let languageId: Int?
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case postId = "post_id"
                case name, url, body, nsfw
                case languageId = "language_id"
                case auth
            }
        }

        struct DeletePost: Codable {
            let postId: Int
            let deleted: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case postId = "post_id"
                case deleted, auth
            }
            
        }
        
        /**
        * Only admins and mods can remove a post.
        */
        struct RemovePost: Codable {
            let postId: Int
            let removed: Bool
            let reason: String?
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case postId = "post_id"
                case removed, reason
                case auth
            }
        }
        
        struct MarkPostAsRead: Codable {
            let postId: Int
            let read: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case postId = "post_id"
                case read
                case auth
            }
        }

        
        /**
        * Only admins and mods can lock a post.
        */
        struct LockPost: Codable {
            let postId: Int
            let locked: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case postId = "post_id"
                case locked, auth
            }
        }
        
        /**
        * Only admins and mods can feature a community a post.
        */
        struct FeaturePost: Codable {
            let editId: Int
            let featured: Bool
            let featureType: RMModels.Others.PostFeatureType
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case editId = "edit_id"
                case featured
                case featureType = "feature_type"
                case auth
            }
        }
        
        struct SavePost: Codable {
            let postId: Int
            let save: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case postId = "post_id"
                case save, auth
            }
        }
                
        struct CreatePostReport: Codable {
            let postId: Int
            let reason: String
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case postId = "post_id"
                case reason, auth
            }
        }
        
        struct PostReportResponse: Codable {
            let postReportView: RMModels.Views.PostReportView
        }
        
        struct ResolvePostReport: Codable {
            let reportId: Int
            /**
            * Either resolve or unresolve a report.
            */
            let resolved: Bool
            let auth: Bool
            
            enum CodingKeys: String, CodingKey {
                case reportId = "report_id"
                case resolved, auth
            }
        }
                
        struct ListPostReports: Codable {
            let page: Int?
            let limit: Int?
            /**
            * if no community is given, it returns reports for all communities moderated by the auth user.
            */
            let communityId: Int?
            /**
             * Only shows the unresolved reports.
             */
            let unresolvedOnly: Bool?
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case page, limit
                case communityId = "community_id"
                case unresolvedOnly = "unresolved_only"
                case auth
            }
        }
        
        struct ListPostReportsResponse: Codable {
            let postReports: [RMModels.Views.PostReportView]
            
            enum CodingKeys: String, CodingKey {
                case postReports = "post_reports"
            }
        }
        
        struct GetSiteMetadata: Codable {
            let url: String
       }

        struct GetSiteMetadataResponse: Codable {
            let metadata: RMModels.Others.SiteMetadata
        }
        
    }
}
