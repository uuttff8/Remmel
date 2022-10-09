//
//  LMModels+Api+Post.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 15.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

extension LMModels.Api {
    enum Post {
        
        struct CreatePost: Codable {
            let name: String
            let url: String?
            let body: String?
            let nsfw: Bool?
            let communityId: Int
            let auth: String
            let honeypot: String?
            
            enum CodingKeys: String, CodingKey {
                case name, url, body, nsfw
                case communityId = "community_id"
                case auth
                case honeypot
            }
        }
        
        struct PostResponse: Codable {
            let postView: LMModels.Views.PostView
            
            enum CodingKeys: String, CodingKey {
                case postView = "post_view"
            }
        }
        
        struct GetPost: Codable {
            let id: Int
            let auth: String?
        }
        
        struct GetPostResponse: Codable {
            let postView: LMModels.Views.PostView
            let communityView: LMModels.Views.CommunityView
            let comments: [LMModels.Views.CommentView]
            let moderators: [LMModels.Views.CommunityModeratorView]
            let online: Int
            
            enum CodingKeys: String, CodingKey {
                case postView = "post_view"
                case communityView = "community_view"
                case comments, moderators, online
            }
        }
        
        /**
        * Post listing types are `All, Subscribed, Community`
        *
        * `community_name` can only be used for local communities.
        * To get posts for a federated community, pass `community_id` instead.
        */
        struct GetPosts: Codable {
            let type: LMModels.Others.ListingType?
            let sort: LMModels.Others.SortType?
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
            let posts: [LMModels.Views.PostView]
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
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case postId = "post_id"
                case name, url, body, nsfw, auth
            }
        }

        /**
         * Only admins and mods can remove a post.
         */
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
        * Only admins and mods can sticky a post.
        */
        struct StickyPost: Codable {
            let editId: Int
            let stickied: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case editId = "edit_id"
                case stickied, auth
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
            let postReportView: LMModels.Views.PostReportView
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
            let postReports: [LMModels.Views.PostReportView]
            
            enum CodingKeys: String, CodingKey {
                case postReports = "post_reports"
            }
        }
        
        struct GetSiteMetadata: Codable {
            let url: String
       }

        struct GetSiteMetadataResponse: Codable {
            let metadata: LMModels.Others.SiteMetadata
        }
        
    }
}
