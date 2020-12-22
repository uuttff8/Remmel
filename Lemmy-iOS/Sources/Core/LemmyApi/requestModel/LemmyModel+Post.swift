//
//  LemmyApiStructs+Post.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

extension LemmyModel {
    enum Post {
                
        // MARK: - GetPosts -
        struct GetPostsRequest: Codable, Equatable {
            let type: LemmyPostListingType
            let sort: LemmySortType
            let page: Int?
            let limit: Int?
            let communityId: Int?
            let communityName: String?
            let auth: String?

            enum CodingKeys: String, CodingKey {
                case type = "type_"
                case sort, page, limit
                case communityId = "community_id"
                case communityName = "community_name"
                case auth
            }
        }

        struct GetPostsResponse: Codable, Equatable {
            let posts: [PostView]
        }

        // MARK: - GetPost -
        struct GetPostRequest: Codable, Equatable {
            let id: Int
            let auth: String?
        }

        struct GetPostResponse: Codable, Equatable {
            let post: PostView
            let comments: [CommentView]
            let community: CommunityView
            let moderators: [CommunityModeratorView]
        }

        // MARK: - CreatePost -
        struct CreatePostRequest: Codable, Equatable {
            let name: String
            let url: String?
            let body: String?
            let nsfw: Bool
            let communityId: Int
            let auth: String

            enum CodingKeys: String, CodingKey {
                case name, url, body, nsfw
                case communityId = "community_id"
                case auth
            }
        }

        struct CreatePostResponse: Codable, Equatable {
            let post: PostView
        }
        
        // MARK: - CreatePostLike -
        struct CreatePostLikeRequest: Codable, Equatable, Hashable {
            let postId: Int
            let score: Int
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case postId = "post_id"
                case score, auth
            }
        }
        
        struct CreatePostLikeResponse: Codable, Equatable, Hashable {
            let post: PostView
        }
        
        // MARK: - CreatePostReport -
        struct CreatePostReportRequest: Codable, Equatable {
            let postId: Int
            let reason: String
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case postId = "post_id"
                case reason, auth
            }
        }
        
        struct CreatePostReportResponse: Codable, Equatable {
            let success: Bool
        }
        
        // MARK: - ResolvePostReport -
        struct ResolvePostReportRequest: Codable, Equatable {
            let reportId: Int
            let resolved: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case reportId = "report_id"
                case resolved, auth
            }
        }
        
        struct ResolvePostReportResponse: Codable, Equatable {
            let reportId: Int
            let resolved: Bool
            
            enum CodingKeys: String, CodingKey {
                case reportId = "report_id"
                case resolved
            }
        }
        
        // MARK: - ListPostReports -
        struct ListPostReportsRequest: Codable, Equatable {
            let page: Int?
            let limit: Int?
            let community: Int?
            let auth: String
        }
        
        struct ListPostReportsResponse: Codable, Equatable {
            let posts: [PostReportView]
        }
    }
}
