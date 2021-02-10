//
//  Aggregates.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 15.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

extension LMModels {
    enum Aggregates {
        struct UserAggregates: Identifiable, Codable {
            let id: Int
            let userId: Int
            let postCount: Int
            let postScore: Int
            let commentCount: Int
            let commentScore: Int
            
            enum CodingKeys: String, CodingKey {
                case id
                case userId = "user_id"
                case postCount = "post_count"
                case postScore = "post_score"
                case commentCount = "comment_count"
                case commentScore = "comment_score"
            }
        }
        
        struct SiteAggregates: Identifiable, Codable {
            let id: Int
            let siteId: Int
            let users: Int
            let posts: Int
            let comments: Int
            let communities: Int
            let usersActiveDay: Int
            let usersActiveWeek: Int
            let usersActiveMonth: Int
            let usersActiveHalfYear: Int
            
            enum CodingKeys: String, CodingKey {
                case id
                case siteId = "site_id"
                case users, posts, comments, communities
                case usersActiveDay = "users_active_day"
                case usersActiveWeek = "users_active_week"
                case usersActiveMonth = "users_active_month"
                case usersActiveHalfYear = "users_active_half_year"
            }
        }
        
        struct PostAggregates: Identifiable, Codable, Hashable, Equatable {
            let id: Int
            let postId: Int
            let comments: Int
            var score: Int
            var upvotes: Int
            var downvotes: Int
            let newestCommentTime: String
            let newestCommentTimeNecro: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case postId = "post_id"
                case newestCommentTime = "newest_comment_time"
                case newestCommentTimeNecro = "newest_comment_time_necro"
                case comments, score, upvotes, downvotes
            }
        }
        
        struct CommunityAggregates: Identifiable, Codable {
            let id: Int
            let communityId: Int
            let subscribers: Int
            let posts: Int
            let comments: Int
            let usersActiveDay: Int
            let usersActiveWeek: Int
            let usersActiveMonth: Int
            let usersActiveHalfYear: Int
            
            enum CodingKeys: String, CodingKey {
                case id
                case communityId = "community_id"
                case subscribers
                case posts, comments
                case usersActiveDay = "users_active_day"
                case usersActiveWeek = "users_active_week"
                case usersActiveMonth = "users_active_month"
                case usersActiveHalfYear = "users_active_half_year"
            }
        }
        
        struct CommentAggregates: Identifiable, Codable, Hashable, Equatable {
            let id: Int
            let commentId: Int
            let score: Int
            let upvotes: Int
            let downvotes: Int
            
            enum CodingKeys: String, CodingKey {
                case id
                case commentId = "comment_id"
                case score, upvotes, downvotes
            }
        }
        
    }
}
