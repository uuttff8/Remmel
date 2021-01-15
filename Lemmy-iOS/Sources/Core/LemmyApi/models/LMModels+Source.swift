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
        struct UserSafe: Identifiable, Codable {
            let id: Int
            let name: String
            let preferredUsername: String
            let avatar: String
            let admin: Bool
            let banned: Bool
            let published: Date
            let updated: Date?
            let matrixUserId: String?
            let actorId: String
            let bio: String?
            let local: Bool
            let banner: String?
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
        
        struct User_: Identifiable, Codable {
            let id: Int
            let name: String
            let preferredUsername: String?
            let passwordEncrypted: String
            let email: String?
            let avatar: String?
            let admin: Bool
            let banned: Bool
            let published: Date
            let updated: Date?
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
            let lastRefreshedAt: String
            let banner: String?
            let deleted: Bool
            
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
                case deleted
            }
        }
        
        struct Site: Identifiable, Codable {
            let id: Int
            let name: String
            let description: String
            let creator_id: Int
            let published: Date
            let updated: Date
            let enable_downvotes: Bool
            let open_registration: Bool
            let enable_nsfw: Bool
            let icon: String?
            let banner: String?
        }
        
        struct PrivateMessage: Identifiable, Codable {
            let id: Int
            let creator_id: Int
            let recipient_id: Int
            let content: String
            let deleted: Bool
            let read: Bool
            let published: Date
            let updated: Date?
            let ap_id: String
            let local: Bool
        }
        
        struct PostReport: Identifiable, Codable {
            let id: Int
            let creator_id: Int
            let post_id: Int
            let original_post_name: String
            let original_post_url: String
            let original_post_body: String
            let reason: String
            let resolved: Bool
            let resolver_id: Int?
            let published: Date
            let updated: String?
        }
        
        struct Post: Identifiable, Codable {
            let id: Int
            let name: String
            let url: String?
            let body: String?
            let creator_id: Int
            let community_id: Int
            let removed: Bool
            let locked: Bool
            let published: Date
            let updated: Date?
            let deleted: Bool
            let nsfw: Bool
            let stickied: Bool
            let embed_title: String
            let embed_description: String?
            let embed_html: String?
            let thumbnail_url: String?
            let ap_id: String
            let local: Bool
        }
        
        struct PasswordResetRequest: Identifiable, Codable {
            let id: Int
            let user_id: Int
            let token_encrypted: String
            let published: Date
        }
        
        struct ModRemovePost: Identifiable, Codable {
            let id: Int
            let mod_user_id: Int
            let post_id: Int
            let reason: String?
            let removed: Bool
            let when_: String
        }
        
        struct ModLockPost: Identifiable, Codable {
            let id: Int
            let mod_user_id: Int
            let post_id: Int
            let locked: Bool?
            let when_: String
        }
        
        struct ModStickyPost: Identifiable, Codable {
            let id: Int
            let mod_user_id: Int
            let post_id: Int
            let stickied: Bool
            let when_: String
        }
        
        struct ModRemoveComment: Identifiable, Codable {
            let id: Int
            let mod_user_id: Int
            let comment_id: Int
            let reason: String?
            let removed: Bool?
            let when_: String
        }
        
        struct ModRemoveCommunity: Identifiable, Codable {
            let id: Int
            let mod_user_id: Int
            let community_id: Int
            let reason: String?
            let removed: Bool?
            let expires: Bool?
            let when_: String
        }
        
        struct ModBanFromCommunity: Identifiable, Codable {
            let id: Int
            let mod_user_id: Int
            let other_user_id: Int
            let community_id: Int
            let reason: String?
            let banned: Bool?
            let expires: String?
            let when_: String
        }
        
        struct ModBan: Identifiable, Codable {
            let id: Int
            let mod_user_id: Int
            let other_user_id: Int
            let reason: String?
            let banned: Bool?
            let expires: String?
            let when_: String
        }
        
        struct ModAddCommunity: Identifiable, Codable {
            let id: Int
            let mod_user_id: Int
            let other_user_id: Int
            let community_id: Int
            let removed: Bool?
            let when_: String
        }
        
        struct ModAdd: Identifiable, Codable {
            let id: Int
            let mod_user_id: Int
            let other_user_id: Int
            let removed: Bool?
            let when_: String
        }
        
        struct CommunitySafe: Identifiable, Codable {
            let id: Int
            let name: String
            let title: String
            let description: String?
            let category_id: Int
            let creator_id: Int
            let removed: Bool
            let published: Date
            let updated: Date?
            let deleted: Bool
            let nsfw: Bool
            let actor_id: String
            let local: Bool
            let icon: String?
            let banner: String?
        }
        
        struct CommentReport: Identifiable, Codable {
            let id: Int
            let creator_id: Int
            let comment_id: Int
            let original_comment_text: String
            let reason: String
            let resolved: Bool
            let resolver_id: Int?
            let published: Date
            let updated: String?
        }
        
        struct Comment: Identifiable, Codable {
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
        
        struct Category: Identifiable, Codable {
            let id: Int
            let name: String
        }
        
        struct UserMention: Identifiable, Codable {
            let id: Int
            let recipient_id: Int
            let comment_id: Int
            let read: Bool
            let published: Date
        }
    }
    
}
