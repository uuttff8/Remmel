//
//  RMModels+Api+Post.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 15.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

public extension RMModels.Api {
    enum Post {
        
        public struct CreatePost: Codable {
            public let name: String
            public let url: String?
            public let body: String?
            public let nsfw: Bool?
            public let languageId: Int?
            public let communityId: Int
            public let honeypot: String?
            public let auth: String
            
            public init(name: String, url: String?, body: String?, nsfw: Bool?, languageId: Int?, communityId: Int, honeypot: String?, auth: String) {
                self.name = name
                self.url = url
                self.body = body
                self.nsfw = nsfw
                self.languageId = languageId
                self.communityId = communityId
                self.honeypot = honeypot
                self.auth = auth
            }
            
            enum CodingKeys: String, CodingKey {
                case name, url, body, nsfw
                case languageId = "language_id"
                case communityId = "community_id"
                case honeypot
                case auth
            }
        }
        
        public struct PostResponse: Codable {
            public let postView: RMModels.Views.PostView
            
            enum CodingKeys: String, CodingKey {
                case postView = "post_view"
            }
        }
        
        public struct GetPost: Codable {
            public let id: Int?
            public let commentId: Int?
            public let auth: String?
            
            public init(id: Int?, commentId: Int?, auth: String?) {
                self.id = id
                self.commentId = commentId
                self.auth = auth
            }
            
            enum CodingKeys: String, CodingKey {
                case id
                case commentId = "comment_id"
                case auth
            }
        }
        
        public struct GetPostResponse: Codable {
            public let postView: RMModels.Views.PostView
            public let communityView: RMModels.Views.CommunityView
            public let moderators: [RMModels.Views.CommunityModeratorView]
            public let online: Int
            
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
        public struct GetPosts: Codable {
            public let type: RMModels.Others.ListingType?
            public let sort: RMModels.Others.SortType?
            public let page: Int?
            public let limit: Int?
            public let communityId: Int?
            public let communityName: String? // To get posts for a federated community by name, use `name@instance.tld` .
            public let savedOnly: Bool?
            public let auth: String?
            
            public init(type: RMModels.Others.ListingType?, sort: RMModels.Others.SortType?, page: Int?, limit: Int?, communityId: Int?, communityName: String?, savedOnly: Bool?, auth: String?) {
                self.type = type
                self.sort = sort
                self.page = page
                self.limit = limit
                self.communityId = communityId
                self.communityName = communityName
                self.savedOnly = savedOnly
                self.auth = auth
            }
            
            enum CodingKeys: String, CodingKey {
                case type = "type_"
                case sort, page, limit
                case communityId = "community_id"
                case communityName = "community_name"
                case auth
                case savedOnly = "saved_only"
            }
        }
        
        public struct GetPostsResponse: Codable {
            public let posts: [RMModels.Views.PostView]
        }
        
        /**
        * `score` can be 0, -1, or 1. Anything else will be rejected.
        */
        public struct CreatePostLike: Codable {
            public let postId: Int
            public let score: Int
            public let auth: String
            
            public init(postId: Int, score: Int, auth: String) {
                self.postId = postId
                self.score = score
                self.auth = auth
            }
            
            enum CodingKeys: String, CodingKey {
                case postId = "post_id"
                case score, auth
            }
        }
        
        public struct EditPost: Codable {
            public let postId: Int
            public let name: String?
            public let url: String?
            public let body: String?
            public let nsfw: Bool?
            public let languageId: Int?
            public let auth: String
            
            public init(postId: Int, name: String?, url: String?, body: String?, nsfw: Bool?, languageId: Int?, auth: String) {
                self.postId = postId
                self.name = name
                self.url = url
                self.body = body
                self.nsfw = nsfw
                self.languageId = languageId
                self.auth = auth
            }
            
            enum CodingKeys: String, CodingKey {
                case postId = "post_id"
                case name, url, body, nsfw
                case languageId = "language_id"
                case auth
            }
        }

        public struct DeletePost: Codable {
            public let postId: Int
            public let deleted: Bool
            public let auth: String
            
            enum CodingKeys: String, CodingKey {
                case postId = "post_id"
                case deleted, auth
            }
            
        }
        
        /**
        * Only admins and mods can remove a post.
        */
        public struct RemovePost: Codable {
            public let postId: Int
            public let removed: Bool
            public let reason: String?
            public let auth: String
            
            enum CodingKeys: String, CodingKey {
                case postId = "post_id"
                case removed, reason
                case auth
            }
        }
        
        public struct MarkPostAsRead: Codable {
            public let postId: Int
            public let read: Bool
            public let auth: String
            
            enum CodingKeys: String, CodingKey {
                case postId = "post_id"
                case read
                case auth
            }
        }

        /**
        * Only admins and mods can lock a post.
        */
        public struct LockPost: Codable {
            public let postId: Int
            public let locked: Bool
            public let auth: String
            
            enum CodingKeys: String, CodingKey {
                case postId = "post_id"
                case locked, auth
            }
        }
        
        /**
        * Only admins and mods can feature a community a post.
        */
        public struct FeaturePost: Codable {
            public let editId: Int
            public let featured: Bool
            public let featureType: RMModels.Others.PostFeatureType
            public let auth: String
            
            enum CodingKeys: String, CodingKey {
                case editId = "edit_id"
                case featured
                case featureType = "feature_type"
                case auth
            }
        }
        
        public struct SavePost: Codable {
            public let postId: Int
            public let save: Bool
            public let auth: String
            
            enum CodingKeys: String, CodingKey {
                case postId = "post_id"
                case save, auth
            }
        }
                
        public struct CreatePostReport: Codable {
            public let postId: Int
            public let reason: String
            public let auth: String
            
            enum CodingKeys: String, CodingKey {
                case postId = "post_id"
                case reason, auth
            }
        }
        
        public struct PostReportResponse: Codable {
            public let postReportView: RMModels.Views.PostReportView
        }
        
        public struct ResolvePostReport: Codable {
            public let reportId: Int
            /**
            * Either resolve or unresolve a report.
            */
            public let resolved: Bool
            public let auth: Bool
            
            enum CodingKeys: String, CodingKey {
                case reportId = "report_id"
                case resolved, auth
            }
        }
                
        public struct ListPostReports: Codable {
            public let page: Int?
            public let limit: Int?
            /**
            * if no community is given, it returns reports for all communities moderated by the auth user.
            */
            public let communityId: Int?
            /**
             * Only shows the unresolved reports.
             */
            public let unresolvedOnly: Bool?
            public let auth: String
            
            enum CodingKeys: String, CodingKey {
                case page, limit
                case communityId = "community_id"
                case unresolvedOnly = "unresolved_only"
                case auth
            }
        }
        
        public struct ListPostReportsResponse: Codable {
            public let postReports: [RMModels.Views.PostReportView]
            
            enum CodingKeys: String, CodingKey {
                case postReports = "post_reports"
            }
        }
        
        public struct GetSiteMetadata: Codable {
            public let url: String
       }

        public struct GetSiteMetadataResponse: Codable {
            public let metadata: RMModels.Others.SiteMetadata
        }
        
    }
}
