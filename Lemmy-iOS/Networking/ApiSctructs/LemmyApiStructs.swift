//
//  LemmyApiStructs.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

enum LemmyApiStructs { }

// Posts
extension LemmyApiStructs {
    
    
    struct PostView: Codable, Equatable {
         let id: Int
         let name: String
         let url: String?
         let body: String?
         let communityId: Int
         let removed: Bool
         let locked: Bool
         let published: String // Timestamp
         let updated: String? // Timestamp
         let deleted: Bool
         let nsfw: Bool
         let stickied: Bool
         let embedTitle: String?
         let embedDescription: String?
         let embedHtml: String?
         let thumbnailUrl: String?
         let apId: String
         let local: Bool
         let creatorActorId: String
         let creatorLocal: Bool
         let creatorName: String
         let creatorPreferredUsername: String?
         let creatorPublished: String // Timestamp
         let creatorAvatar: String?
         let banned: Bool
         let bannedFromCommunity: Bool
         let communityActorId: String
         let communityLocal: Bool
         let communityName: String
         let communityIcon: String?
         let communityRemoved: Bool
         let communityDeleted: Bool
         let communityNsfw: Bool
         let numberOfComments: Int
         let score: Int
         let upvotes: Int
         let downvotes: Int
         let hotRank: Int
         let hotRankActive: Int
         let newestActivityTime: String // Timestamp
         let userId: Int?
         let myVote: Int?
         let subscribed: Bool?
         let read: Bool?
         let saved: Bool?
         
         enum CodingKeys: String, CodingKey {
             case id, name, url, body
             case communityId = "community_id"
             case removed, locked, published, updated, deleted, nsfw, stickied
             case embedTitle = "embed_title"
             case embedDescription = "embed_description"
             case embedHtml = "embed_html"
             case thumbnailUrl = "thumbnail_url"
             case apId = "ap_id", local
             case creatorActorId = "creator_actor_id"
             case creatorLocal = "creator_local"
             case creatorName = "creator_name"
             case creatorPreferredUsername = "creator_preferred_username"
             case creatorPublished = "creator_published"
             case creatorAvatar = "creator_avatar", banned
             case bannedFromCommunity = "banned_from_community"
             case communityActorId = "community_actor_id"
             case communityLocal = "community_local"
             case communityName = "community_name"
             case communityIcon = "community_icon"
             case communityRemoved = "community_removed"
             case communityDeleted = "community_deleted"
             case communityNsfw = "community_nsfw"
             case numberOfComments = "number_of_comments"
             case score, upvotes, downvotes
             case hotRank = "hot_rank"
             case hotRankActive = "hot_rank_active"
             case newestActivityTime = "newest_activity_time"
             case userId = "user_id"
             case myVote = "my_vote", subscribed, read, saved
         }
     }
    
    struct CommentView: Codable, Equatable {
        let id: Int
        let creatorId: Int
        let postId: Int
        let postName: String
        let parentId: Int?
        let content: String
        let removed: Bool
        let published: String // Timestamp
        let updated: String? // Timestamp
        let deleted: Bool
        let apId: String
        let local: Bool
        let communityId: Int
        let communityActorId: String
        let communityLocal: Bool
        let communityName: String
        let communityIcon: String?
        let banned: Bool
        let bannedFromCommunity: Bool
        let creatorActorId: String
        let creatorLocal: Bool
        let creatorName: String
        let creatorPreferredUsername: String?
        let creatorPublished: String // Timestamp
        let creatorAvatar: String?
        let score: Int
        let upvotes: Int
        let downvotes: Int
        let hotRank: Int
        let hotRankActive: Int
        let userId: Int?
        let myVote: Int?
        let subscribed: Bool?
        let read: Bool
        let saved: Bool?
        
        enum CodingKeys: String, CodingKey {
            case id, content
            case creatorId = "creator_id"
            case postId = "post_id"
            case postName = "post_name"
            case parentId = "parent_id"
            case communityId = "community_id"
            case removed, published, updated, deleted
            case apId = "ap_id", local
            case creatorActorId = "creator_actor_id"
            case creatorLocal = "creator_local"
            case creatorName = "creator_name"
            case creatorPreferredUsername = "creator_preferred_username"
            case creatorPublished = "creator_published"
            case creatorAvatar = "creator_avatar", banned
            case bannedFromCommunity = "banned_from_community"
            case communityActorId = "community_actor_id"
            case communityLocal = "community_local"
            case communityName = "community_name"
            case communityIcon = "community_icon"
            case score, upvotes, downvotes
            case hotRank = "hot_rank"
            case hotRankActive = "hot_rank_active"
            case userId = "user_id"
            case myVote = "my_vote"
            case subscribed, read, saved
        }
    }
    
    struct CommunityView {
        let id: Int
        let name, title: String
        let icon, banner, description: String?
        let categoryId, creatorId: Int
        let removed: Bool
        let published: String // Timestamp
        let updated: String? // Timestamp
        let deleted, nsfw, local: Bool
        let actorId: String
        let lastRefreshedAt: String // Timestamp
        let creatorActorId: String
        let creatorLocal: Bool
        let creatorName: String
        let creatorPreferredUsername: String?
        let creatorAvatar: String?
        let categoryName: String
        let numberOfSubscribers: Int
        let numberOfPosts: Int
        let numberOfComments: Int
        let hotRank: Int
        let userId: Int?
        let subscribed: Bool?
        
        enum CodingKeys: String, CodingKey {
            case id, name, title, icon, banner, description
            case categoryId = "category_id"
            case creatorId = "creator_id"
            case removed, published, updated, deleted, nsfw, local
            case actorId = "actor_id"
            case lastRefreshedAt = "last_refreshed_at"
            case creatorActorId = "creator_actor_id"
            case creatorLocal = "creator_local"
            case creatorName = "creator_name"
            case creatorPreferredUsername = "creator_preferred_username"
            case creatorAvatar = "creator_avatar"
            case categoryName = "category_name"
            case numberOfSubscribers = "number_of_subscribers"
            case numberOfPosts = "number_of_posts"
            case numberOfComments = "number_of_comments"
            case hotRank = "hot_rank"
            case userId = "user_id"
            case subscribed
        }
    }
    
    struct CommunityModeratorView: Codable, Equatable {
        let id: Int
        let communityId: Int
        let userId: Int
        let published: String // Timestamp
        let userActorId: String
        let userLocal: Bool
        let userName: String
        let userPreferredUsermame: String?
        let avatar: String?
        let communityActorId: String
        let communityLocal: Bool
        let communityName: String
        let communityIcon: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case communityId = "community_id"
            case userId = "user_id"
            case published
            case userActorId = "user_actor_id"
            case userLocal = "user_local"
            case userName = "user_name"
            case userPreferredUsermame = "user_preferred_username"
            case avatar = "avatar"
            case communityActorId = "community_actor_id"
            case communityLocal = "community_local"
            case communityName = "community_name"
            case communityIcon = "community_icon"
        }
    }
    
    enum Post {
                
        struct GetPostsRequest: Codable, Equatable {
            let type_: String
            let sort: String
            let page: Int?
            let limit: Int?
            let communityId: Int?
            let communityName: String?
            let auth: String?
            
            enum CodingKeys: String, CodingKey {
                case type_ = "type_"
                case sort, page, limit
                case communityId = "community_id"
                case communityName = "community_name"
                case auth
            }
        }
        
        struct GetPostsResponse: Codable, Equatable {
            let posts: Array<PostView>
        }
        
        struct GetPostRequest: Codable, Equatable {
            let id: Int
            let auth: String?
        }
        
//        struct GetPostResponse: Codable, Equatable {
//            let post: PostView
//            let comments: Array<CommentView>
//            let community:
//        }
        
    }
}
