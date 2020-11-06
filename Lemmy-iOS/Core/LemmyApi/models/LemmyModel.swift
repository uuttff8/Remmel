//
//  LemmyModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

enum LemmyModel {

    // MARK: - PostView -
    struct PostView: Codable, Equatable, Hashable {
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
        
        func getUrlDomain() -> String? {
            let type = PostType.getPostType(from: self)
            
            guard !(.none == type) else { return nil }
            guard let urlStr = self.url,
                  let urlDomain = URL(string: urlStr)
                  else { return nil }
            
            return urlDomain.host
        }
    }

    // MARK: - CommentView -
    struct CommentView: Codable, Equatable, Hashable {
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

    struct ModRemoveCommentView: Codable, Equatable, Hashable {
        let id: Int
        let modUserId: Int
        let commentId: Int
        let reason: String?
        let removed: Bool?
        let when: String // Timestamp
        let modUsername: String
        let commentUserId: Int
        let commentUsername: String
        let commentContent: String
        let postId: Int
        let postName: String
        let communityId: Int
        let communityName: String

        enum CodingKeys: String, CodingKey {
            case id
            case modUserId = "mod_user_id"
            case commentId = "comment_id"
            case reason, removed
            case when = "when_"
            case modUsername = "mod_user_name"
            case commentUserId = "comment_user_id"
            case commentUsername = "comment_user_name"
            case commentContent = "comment_content"
            case postId = "post_id"
            case postName = "post_name"
            case communityId = "community_id"
            case communityName = "community_name"
        }
    }

    // MARK: - CommunityView -
    struct CommunityView: Codable, Equatable, Hashable {
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

    struct ModRemoveCommunityView: Codable, Equatable, Hashable {
        let id: Int
        let modUserId: Int
        let communityId: Int
        let reason: String?
        let removed: Bool?
        let expires: String? // Timestamp
        let when: String // Timestamp
        let modUsername: String
        let communityName: String

        enum CodingKeys: String, CodingKey {
            case id
            case modUserId = "mod_user_id"
            case communityId = "community_id"
            case reason, removed, expires
            case when = "when_"
            case modUsername = "mod_user_name"
            case communityName = "community_name"
        }
    }

    struct ModBanFromCommunityView: Codable, Equatable, Hashable {
        let id: Int
        let modUserId: Int
        let otherUserId: Int
        let communityId: Int
        let reason: String?
        let banned: Bool?
        let expires: String? // Timestamp
        let when: String // Timestamp
        let modUsername: String
        let otherUsername: String
        let communityName: String

        enum CodingKeys: String, CodingKey {
            case id
            case modUserId = "mod_user_id"
            case otherUserId = "other_user_id"
            case communityId = "community_id"
            case reason, banned, expires
            case when = "when_"
            case modUsername = "mod_user_name"
            case otherUsername = "other_user_name"
            case communityName = "community_name"
        }
    }

    struct ModAddCommunityView: Codable, Equatable, Hashable {
        let id: Int
        let modUserId: Int
        let otherUserId: Int
        let communityId: Int
        let removed: Bool?
        let when: String // Timestamp
        let modUsername: String
        let otherUsername: String
        let communityName: String

        enum CodingKeys: String, CodingKey {
            case id
            case modUserId = "mod_user_id"
            case otherUserId = "other_user_id"
            case communityId = "community_id"
            case removed
            case when = "when_"
            case modUsername = "mod_user_name"
            case otherUsername = "other_user_name"
            case communityName = "community_name"
        }
    }

    // MARK: - CommunityModeratorView -
    struct CommunityModeratorView: Codable, Equatable, Hashable {
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

    struct ModRemovePostView: Codable, Equatable, Hashable {
        let id: Int
        let modUserId: Int
        let postId: Int
        let reason: String?
        let removed: Bool?
        let when: String // Timestamp
        let modUserName: String
        let postName: String
        let communityId: Int
        let communityName: String

        enum CodingKeys: String, CodingKey {
            case id
            case modUserId = "mod_user_id"
            case postId = "post_id"
            case reason, removed
            case when = "when_"
            case modUserName = "mod_user_name"
            case postName = "post_name"
            case communityId = "community_id"
            case communityName = "community_name"
        }
    }

    struct ModLockPostView: Codable, Equatable, Hashable {
        let id: Int
        let modUserId: Int
        let postId: Int
        let locked: Bool?
        let when: String // Timestamp
        let modUsername: String
        let postName: String
        let communityId: Int
        let communityName: String

        enum CodingKeys: String, CodingKey {
            case id
            case modUserId = "mod_user_id"
            case postId = "post_id"
            case locked
            case when = "when_"
            case modUsername = "mod_user_name"
            case postName = "post_name"
            case communityId = "community_id"
            case communityName = "community_name"
        }
    }

    struct ModStickyPostView: Codable, Equatable, Hashable {
        let id: Int
        let modUserId: Int
        let postId: Int
        let stickied: Bool?
        let when: String // Timestamp
        let modUsername: String
        let postName: String
        let communityId: Int
        let communityName: String

        enum CodingKeys: String, CodingKey {
            case id
            case modUserId = "mod_user_id"
            case postId = "post_id"
            case stickied
            case when = "when_"
            case modUsername = "mod_user_name"
            case postName = "post_name"
            case communityId = "community_id"
            case communityName = "community_name"
        }
    }

    // MARK: - UserView -
    struct UserView: Codable, Equatable, Hashable {
        let id: Int
        let actorId: String
        let name: String
        let preferredUsername: String?
        let avatar: String?
        let banner: String?
        let matrixUserId: String?
        let bio: String?
        let local: Bool
        let admin: Bool
        let banned: Bool
        let published: String
        let numberOfPosts: Int
        let postScore: Int
        let numberOfComments: Int
        let commentScore: Int

        enum CodingKeys: String, CodingKey {
            case id
            case actorId = "actor_id"
            case name
            case preferredUsername = "preferred_username"
            case avatar, banner
            case matrixUserId = "matrix_user_id"
            case bio, local, admin, banned, published
            case numberOfPosts = "number_of_posts"
            case postScore = "post_score"
            case numberOfComments = "number_of_comments"
            case commentScore = "comment_score"
        }
    }

    // MARK: - MyUser -
    // inner struct in lemmy backend called User_, that is why its not a *View
    struct MyUser: Codable, Equatable {
        let id: Int
        let name: String
        let preferredUsername: String?
        let passwordEncrypted: String
        let email: String
        let avatar: String?
        let admin: Bool
        let banned: Bool
        let published: String // Timestamp
        let updated: String? // Timestamp
        let showNsfw: Bool
        let theme: String
        let defaultSortType: Int
        let defaultListingType: Int
        let lang: String
        let showAvatars: Bool
        let sendNotificationsToEmail: Bool
        let matrixUserId: String?
        let actorId: String
        let bio: String?
        let local: Bool
        let privateKey: String?
        let publicKey: String?
        let lastRefreshedAt: String // Timestamp
        let banner: String?

        enum CodingKeys: String, CodingKey {
            case id, name
            case preferredUsername = "preferred_username"
            case passwordEncrypted = "password_encrypted"
            case email, avatar, admin, banned
            case published, updated
            case showNsfw = "show_nsfw"
            case theme
            case defaultSortType = "default_sort_type"
            case defaultListingType = "default_listing_type"
            case lang
            case showAvatars = "show_avatars"
            case sendNotificationsToEmail = "send_notifications_to_email"
            case matrixUserId = "matrix_user_id"
            case actorId = "actor_id"
            case bio, local
            case privateKey = "private_key"
            case publicKey = "public_key"
            case lastRefreshedAt = "last_refreshed_at"
            case banner
        }
    }

    struct ModBanView: Codable, Equatable, Hashable {
        let id: Int
        let modUserId: Int
        let otherUserId: Int
        let reason: String?
        let banned: Bool?
        let expires: String?
        let when: String
        let modUsername: String
        let otherUsername: String

        enum CodingKeys: String, CodingKey {
            case id
            case modUserId = "mod_user_id"
            case otherUserId = "other_user_id"
            case reason, banned, expires
            case when = "when_"
            case modUsername = "mod_user_name"
            case otherUsername = "other_user_name"
        }
    }

    struct ModAddView: Codable, Equatable, Hashable {
        let id: Int
        let modUserId: Int
        let otherUserId: Int
        let removed: Bool?
        let when: String // Timestamp
        let modUsername: String
        let otherUsername: String

        enum CodingKeys: String, CodingKey {
            case id
            case modUserId = "mod_user_id"
            case otherUserId = "other_user_id"
            case removed
            case when = "when_"
            case modUsername = "mod_user_name"
            case otherUsername = "other_user_name"
        }
    }

    // MARK: - CommunityFollowerView -
    struct CommunityFollowerView: Codable, Equatable {
        let id: Int
        let communityId: Int
        let userId: Int
        let published: String
        let userActorId: String
        let userLocal: Bool
        let userName: String
        let userPreferredUsername: String?
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
            case userPreferredUsername = "user_preferred_username"
            case avatar
            case communityActorId = "community_actor_id"
            case communityLocal = "community_local"
            case communityName = "community_name"
            case communityIcon = "community_icon"
        }
    }

    // MARK: - ReplyView -
    struct ReplyView: Codable, Equatable {
        let id: Int
        let creatorId: Int
        let postId: Int
        let postName: String
        let parentId: Int?
        let content: String
        let removed: Bool
        let read: Bool
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
        let creatorAvatar: String?
        let creatorPublished: String // Timestamp
        let score: Int
        let upvotes: Int
        let downvotes: Int
        let hotRank: Int
        let hotRankActive: Int
        let userId: Int?
        let myVote: Int?
        let subscribed: Bool?
        let saved: Bool?
        let recipientId: Int

        enum CodingKeys: String, CodingKey {
            case id
            case creatorId = "creator_id"
            case postId = "post_id"
            case postName = "post_name"
            case parentId = "parent_id"
            case content, removed, read
            case published, updated, deleted
            case apId = "ap_id"
            case local
            case communityId = "community_id"
            case communityActorId = "community_actor_id"
            case communityLocal = "community_local"
            case communityName = "community_name"
            case communityIcon = "community_icon"
            case banned
            case bannedFromCommunity = "banned_from_community"
            case creatorActorId = "creator_actor_id"
            case creatorLocal = "creator_local"
            case creatorName = "creator_name"
            case creatorPreferredUsername = "creator_preferred_username"
            case creatorAvatar = "creator_avatar"
            case creatorPublished = "creator_published"
            case score, upvotes, downvotes
            case hotRank = "hot_rank"
            case hotRankActive = "hot_rank_active"
            case userId = "user_id"
            case myVote = "my_vote"
            case subscribed, saved
            case recipientId = "recipient_id"
        }
    }

    // MARK: - UserMentionView -
    struct UserMentionView: Codable, Equatable {
        let id: Int
        let userMentionId: Int
        let creatorId: Int
        let creatorActorId: String
        let creatorLocal: Bool
        let postId: Int
        let postName: String
        let parentId: Int?
        let content: String
        let removed: Bool
        let read: Bool
        let published: String // Timestamp
        let updated: String? // Timestamp
        let deleted: Bool
        let communityId: Int
        let communityActorId: String
        let communityLocal: Bool
        let communityName: String
        let communityIcon: String?
        let banned: Bool
        let bannedFromCommunity: Bool
        let creatorName: String
        let creatorPreferredUsername: String
        let creatorAvatar: String?
        let score: Int
        let upvotes: Int
        let downvotes: Int
        let hotRank: Int
        let hotRankActive: Int
        let userId: Int?
        let myVote: Int?
        let saved: Bool?
        let recipientId: Int
        let recipientActorId: String
        let recipientLocal: Bool

        enum CodingKeys: String, CodingKey {
            case id
            case userMentionId = "user_mention_id"
            case creatorId = "creator_id"
            case creatorActorId = "creator_actor_id"
            case creatorLocal = "creator_local"
            case postId = "post_id"
            case postName = "post_name"
            case parentId = "parent_id"
            case content, removed, read, published
            case updated, deleted
            case communityId = "community_id"
            case communityActorId = "community_actor_id"
            case communityLocal = "community_local"
            case communityName = "community_name"
            case communityIcon = "community_icon"
            case banned
            case bannedFromCommunity = "banned_from_community"
            case creatorName = "creator_name"
            case creatorPreferredUsername = "creator_preferred_username"
            case creatorAvatar = "creator_avatar"
            case score, upvotes, downvotes
            case hotRank = "hot_rank"
            case hotRankActive = "hot_rank_active"
            case userId = "user_id"
            case myVote = "my_vote"
            case saved
            case recipientId = "recipient_id"
            case recipientActorId = "recipient_actor_id"
            case recipientLocal = "recipient_local"
        }
    }

    // MARK: - SiteView -
    struct SiteView: Codable, Equatable {
        let id: Int
        let name: String
        let description: String?
        let creatorId: Int
        let published: String // Timestamp
        let updated: String? // Timestamp
        let enableDownvotes: Bool
        let openRegistration: Bool
        let enableNsfw: Bool
        let icon: String?
        let banner: String?
        let creatorName: String
        let creatorPreferredUsername: String?
        let creatorAvatar: String?
        let numberOfUsers: Int
        let numberOfPosts: Int
        let numberOfComments: Int
        let numberOfCommunities: Int

        enum CodingKeys: String, CodingKey {
            case id, name, description
            case creatorId = "creator_id"
            case published, updated
            case enableDownvotes = "enable_downvotes"
            case openRegistration = "open_registration"
            case enableNsfw = "enable_nsfw"
            case icon, banner
            case creatorName = "creator_name"
            case creatorPreferredUsername = "creator_preferred_username"
            case creatorAvatar = "creator_avatar"
            case numberOfUsers = "number_of_users"
            case numberOfPosts = "number_of_posts"
            case numberOfComments = "number_of_comments"
            case numberOfCommunities = "number_of_communities"
        }
    }

    // MARK: - PrivateMessageView -
    struct PrivateMessageView: Codable, Equatable, Hashable {
        let id: Int
        let creatorId: Int
        let recipientId: Int
        let content: String
        let deleted: Bool
        let read: Bool
        let published: String // Timestamp
        let updated: String? // Timestamp
        let apId: String
        let local: Bool
        let creatorPreferredUsername: String?
        let creatorAvatar: String?
        let creatorActorId: String
        let creatorLocal: Bool
        let recipientName: String
        let recipientPreferredUsername: String?
        let recipientAvatar: String?
        let recipientActorId: String
        let recipientLocal: Bool

        enum CodingKeys: String, CodingKey {
            case id
            case creatorId = "creator_id"
            case recipientId = "recipient_id"
            case content, deleted, read
            case published, updated
            case apId = "ap_id"
            case local
            case creatorPreferredUsername = "creator_preferred_username"
            case creatorAvatar = "creator_avatar"
            case creatorActorId = "creator_actor_id"
            case creatorLocal = "creator_local"
            case recipientName = "recipient_name"
            case recipientPreferredUsername = "recipient_preferred_username"
            case recipientAvatar = "recipient_avatar"
            case recipientActorId = "recipient_actor_id"
            case recipientLocal = "recipient_local"
        }
    }

    // MARK: - CategoryView -
    // usually referred in lemmy-db as just Category, we name it *_View just because convention
    struct CategoryView: Codable, Equatable, Hashable {
        let id: Int
        let name: String
    }
}
