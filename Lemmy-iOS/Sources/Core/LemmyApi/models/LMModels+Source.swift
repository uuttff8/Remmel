//
//  Source.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 15.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

extension LMModels {
    
    enum Source {
        struct UserSafe: Identifiable, Codable, Hashable, Equatable {
            let id: Int
            let name: String
            let preferredUsername: String?
            let avatar: URL?
            let admin: Bool
            let banned: Bool
            let published: Date
            let updated: Date?
            let matrixUserId: String?
            let actorId: URL
            let bio: String?
            let local: Bool
            let banner: URL?
            let deleted: Bool
            
            enum CodingKeys: String, CodingKey {
                case id, name
                case preferredUsername = "preferred_username"
                case avatar, admin, banned, published, updated
                case matrixUserId = "matrix_user_id"
                case actorId = "actor_id"
                case bio, local, banner, deleted
            }
        }
        
        struct UserSafeSettings: Identifiable, Codable {
            let id: Int
            let name: String
            let preferredUsername: String?
            let email: String?
            let avatar: String?
            let admin: Bool
            let banned: Bool
            let published: Date
            let updated: Date?
            let showNsfw: Bool
            let theme: String
            let defaultSortType: LMModels.Others.SortType
            let defaultListingType: LMModels.Others.ListingType
            let lang: String
            let showAvatars: Bool
            let sendNotificationsToEmail: Bool
            let matrixUserId: String?
            let actorId: URL
            let bio: String?
            let local: Bool
            let lastRefreshedAt: String
            let banner: String?
            let deleted: Bool
            
            enum CodingKeys: String, CodingKey {
                case id, name
                case preferredUsername = "preferred_username"
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
                case lastRefreshedAt = "last_refreshed_at"
                case banner
                case deleted
            }
        }
        
        struct Site: Identifiable, Codable {
            let id: Int
            let name: String
            let description: String
            let creatorId: Int
            let published: Date
            let updated: Date
            let enableDownvotes: Bool
            let openRegistration: Bool
            let enableNsfw: Bool
            let icon: URL?
            let banner: URL?
            
            enum CodingKeys: String, CodingKey {
                case id
                case name, description
                case creatorId = "creator_id"
                case published, updated
                case enableDownvotes = "enable_downvotes"
                case openRegistration = "open_registration"
                case enableNsfw = "enable_nsfw"
                case icon, banner
            }
        }
        
        struct PrivateMessage: Identifiable, Codable {
            let id: Int
            let creatorId: Int
            let recipientId: Int
            let content: String
            let deleted: Bool
            let read: Bool
            let published: Date
            let updated: Date?
            let apId: String
            let local: Bool
            
            enum CodingKeys: String, CodingKey {
                case id
                case creatorId = "creator_id"
                case recipientId = "recipient_id"
                case content, deleted, read, published, updated
                case apId = "ap_id"
                case local
            }
        }
        
        struct PostReport: Identifiable, Codable {
            let id: Int
            let creatorId: Int
            let postId: Int
            let originalPostName: String
            let originalPostUrl: URL
            let originalPostBody: String
            let reason: String
            let resolved: Bool
            let resolverId: Int?
            let published: Date
            let updated: String?
            
            enum CodingKeys: String, CodingKey {
                case id
                case creatorId = "creator_id"
                case postId = "post_id"
                case originalPostName = "original_post_name"
                case originalPostUrl = "original_post_url"
                case originalPostBody = "original_post_body"
                case reason, resolved
                case resolverId = "resolver_id"
                case published, updated
            }
        }
        
        struct Post: Identifiable, Codable, Hashable, Equatable {
            let id: Int
            let name: String
            let url: URL?
            let body: String?
            let creatorId: Int
            let communityId: Int
            let removed: Bool
            let locked: Bool
            let published: Date
            let updated: Date?
            let deleted: Bool
            let nsfw: Bool
            let stickied: Bool
            let embedTitle: String?
            let embedDescription: String?
            let embedHtml: String?
            let thumbnailUrl: URL?
            let apId: String
            let local: Bool
            
            enum CodingKeys: String, CodingKey {
                case id
                case name, url, body, removed
                case locked, published, updated, deleted
                case nsfw, stickied
                case creatorId = "creator_id"
                case communityId = "community_id"
                case embedTitle = "embed_title"
                case embedDescription = "embed_description"
                case embedHtml = "embed_html"
                case thumbnailUrl = "thumbnail_url"
                case apId = "ap_id"
                case local
            }
        }
        
        struct PasswordResetRequest: Identifiable, Codable {
            let id: Int
            let userId: Int
            let tokenEncrypted: String
            let published: Date
            
            enum CodingKeys: String, CodingKey {
                case id
                case userId = "user_id"
                case tokenEncrypted = "token_encrypted"
                case published
            }
        }
        
        struct ModRemovePost: Identifiable, Codable {
            let id: Int
            let modUserId: Int
            let postId: Int
            let reason: String?
            let removed: Bool
            let when: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case modUserId = "mod_user_id"
                case postId = "post_id"
                case reason, removed
                case when = "when_"
            }
        }
        
        struct ModLockPost: Identifiable, Codable {
            let id: Int
            let modUserId: Int
            let postId: Int
            let locked: Bool?
            let when: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case modUserId = "mod_user_id"
                case postId = "post_id"
                case locked
                case when = "when_"
            }
        }
        
        struct ModStickyPost: Identifiable, Codable {
            let id: Int
            let modUserId: Int
            let postId: Int
            let stickied: Bool
            let when: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case modUserId = "mod_user_id"
                case postId = "post_id"
                case stickied
                case when = "when_"
            }
        }
        
        struct ModRemoveComment: Identifiable, Codable {
            let id: Int
            let modUserId: Int
            let commentId: Int
            let reason: String?
            let removed: Bool?
            let when: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case modUserId = "mod_user_id"
                case commentId = "comment_id"
                case removed, reason
                case when = "when_"
            }
        }
        
        struct ModRemoveCommunity: Identifiable, Codable {
            let id: Int
            let modUserId: Int
            let communityId: Int
            let reason: String?
            let removed: Bool?
            let expires: Bool?
            let when: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case modUserId = "mod_user_id"
                case communityId = "community_id"
                case expires, removed, reason
                case when = "when_"
            }
        }
        
        struct ModBanFromCommunity: Identifiable, Codable {
            let id: Int
            let modUserId: Int
            let otherUserId: Int
            let communityId: Int
            let reason: String?
            let banned: Bool?
            let expires: String?
            let when: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case modUserId = "mod_user_id"
                case otherUserId = "other_user_id"
                case communityId = "community_id"
                case expires, banned, reason
                case when = "when_"
            }
        }
        
        struct ModBan: Identifiable, Codable {
            let id: Int
            let modUserId: Int
            let otherUserId: Int
            let reason: String?
            let banned: Bool?
            let expires: String?
            let when: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case modUserId = "mod_user_id"
                case otherUserId = "other_user_id"
                case expires, banned, reason
                case when = "when_"
            }
        }
        
        struct ModAddCommunity: Identifiable, Codable {
            let id: Int
            let modUserId: Int
            let otherUserId: Int
            let communityId: Int
            let removed: Bool?
            let when: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case modUserId = "mod_user_id"
                case otherUserId = "other_user_id"
                case communityId = "community_id"
                case removed
                case when = "when_"
            }
        }
        
        struct ModAdd: Identifiable, Codable {
            let id: Int
            let modUserId: Int
            let otherUserId: Int
            let removed: Bool?
            let when: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case modUserId = "mod_user_id"
                case otherUserId = "other_user_id"
                case removed
                case when = "when_"
            }
        }
        
        struct CommunitySafe: Identifiable, Codable, Hashable, Equatable {
            let id: Int
            let name: String
            let title: String
            let description: String?
            let categoryId: Int
            let creatorId: Int
            let removed: Bool
            let published: Date
            let updated: Date?
            let deleted: Bool
            let nsfw: Bool
            let actorId: URL
            let local: Bool
            let icon: URL?
            let banner: URL?
            
            enum CodingKeys: String, CodingKey {
                case id
                case name, title, description
                case categoryId = "category_id"
                case creatorId = "creator_id"
                case removed, published, updated, deleted
                case nsfw
                case actorId = "actor_id"
                case local, icon, banner
            }
        }
        
        struct CommentReport: Identifiable, Codable {
            let id: Int
            let creatorId: Int
            let commentId: Int
            let originalCommentText: String
            let reason: String
            let resolved: Bool
            let resolverId: Int?
            let published: Date
            let updated: String?
            
            enum CodingKeys: String, CodingKey {
                case id
                case creatorId = "creator_id"
                case commentId = "comment_id"
                case originalCommentText = "original_comment_text"
                case reason, resolved
                case resolverId = "resolver_id"
                case published, updated
            }
        }
        
        struct Comment: Identifiable, Codable, Hashable, Equatable {
            let id: Int
            let creatorId: Int
            let postId: Int
            let parentId: Int?
            let content: String
            let removed: Bool
            let read: Bool // Whether the recipient has read the comment or not
            let published: Date
            let updated: Date?
            let deleted: Bool
            let apId: String
            let local: Bool
            
            enum CodingKeys: String, CodingKey {
                case id
                case creatorId = "creator_id"
                case postId = "post_id"
                case parentId = "parent_id"
                case content, removed, read
                case published, updated
                case deleted
                case apId = "ap_id"
                case local
            }
        }
        
        struct Category: Identifiable, Codable, Equatable, Hashable {
            let id: Int
            let name: String
        }
        
        struct UserMention: Identifiable, Codable {
            let id: Int
            let recipientId: Int
            let commentId: Int
            let read: Bool
            let published: Date
            
            enum CodingKeys: String, CodingKey {
                case id
                case recipientId = "recipient_id"
                case commentId = "comment_id"
                case read, published
            }
        }
    }
    
}
