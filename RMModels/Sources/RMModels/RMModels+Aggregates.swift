//
//  Aggregates.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 15.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

public extension RMModels {
    enum Aggregates {
        public struct PersonAggregates: Identifiable, Codable {
            public let id: Int
            public let personId: Int
            public let postCount: Int
            public let postScore: Int
            public let commentCount: Int
            public let commentScore: Int
            
            enum CodingKeys: String, CodingKey {
                case id
                case personId = "person_id"
                case postCount = "post_count"
                case postScore = "post_score"
                case commentCount = "comment_count"
                case commentScore = "comment_score"
            }
        }
        
        public struct SiteAggregates: Identifiable, Codable {
            public let id: Int
            public let siteId: Int
            public let users: Int
            public let posts: Int
            public let comments: Int
            public let communities: Int
            public let usersActiveDay: Int
            public let usersActiveWeek: Int
            public let usersActiveMonth: Int
            public let usersActiveHalfYear: Int
            
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
        
        public struct PostAggregates: Identifiable, Codable, Hashable, Equatable {
            public let id: Int
            public let postId: Int
            public let comments: Int
            public var score: Int
            public var upvotes: Int
            public var downvotes: Int
            public let newestCommentTime: String
            public let newestCommentTimeNecro: String
            public let featuredCommunity: Bool
            public let featuredLocal: Bool
            
            enum CodingKeys: String, CodingKey {
                case id
                case postId = "post_id"
                case newestCommentTime = "newest_comment_time"
                case newestCommentTimeNecro = "newest_comment_time_necro"
                case featuredCommunity = "featured_community"
                case featuredLocal = "featured_local"
                case comments, score, upvotes, downvotes
            }
        }
        
        public struct CommunityAggregates: Identifiable, Codable {
            public let id: Int
            public let communityId: Int
            public let subscribers: Int
            public let posts: Int
            public let comments: Int
            public let usersActiveDay: Int
            public let usersActiveWeek: Int
            public let usersActiveMonth: Int
            public let usersActiveHalfYear: Int
            
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
        
        public struct CommentAggregates: Identifiable, Codable, Hashable, Equatable {
            public let id: Int
            public let commentId: Int
            public var score: Int
            public var upvotes: Int
            public var downvotes: Int
            public let childCount: Int
            
            enum CodingKeys: String, CodingKey {
                case id
                case commentId = "comment_id"
                case score, upvotes, downvotes
                case childCount = "child_count"
            }
        }
    }
}
