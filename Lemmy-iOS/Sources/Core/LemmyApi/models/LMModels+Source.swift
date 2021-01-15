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
        struct UserSafe: Codable {
          let id: Int
          let name: String
          let preferred_username: String
          let avatar: String
          let admin: Bool
          let banned: Bool
          let published: String
          let updated: String?
          let matrix_user_id: String?
          let actor_id: String
          let bio: String?
          let local: Bool
          let banner: String?
          let deleted: Bool
        }

        struct User_: Codable {
          let id: Int
          let name: String
          let preferred_username: String?
          let password_encrypted: String
          let email: String?
          let avatar: String?
          let admin: Bool
          let banned: Bool
          let published: String
          let updated: String?
          let show_nsfw: Bool
          let theme: String
          let default_sort_type: Int
          let default_listing_type: Int
          let lang: String
          let show_avatars: Bool
          let send_notifications_to_email: Bool
          let matrix_user_id: String?
          let actor_id: String
          let bio: String?
          let local: Bool
          let private_key: String?
          let public_key: String?
          let last_refreshed_at: String
          let banner: String?
          let deleted: Bool
        }

        struct Site: Codable {
          let id: Int
          let name: String
          let description: String
          let creator_id: Int
          let published: String
          let updated: String
          let enable_downvotes: Bool
          let open_registration: Bool
          let enable_nsfw: Bool
          let icon: String?
          let banner: String?
        }

        struct PrivateMessage: Codable {
          let id: Int
          let creator_id: Int
          let recipient_id: Int
          let content: String
          let deleted: Bool
          let read: Bool
          let published: String
          let updated: String?
          let ap_id: String
          let local: Bool
        }

        struct PostReport: Codable {
          let id: Int
          let creator_id: Int
          let post_id: Int
          let original_post_name: String
          let original_post_url: String
          let original_post_body: String
          let reason: String
          let resolved: Bool
          let resolver_id: Int?
          let published: String
          let updated: String?
        }

        struct Post: Codable {
          let id: Int
          let name: String
          let url: String?
          let body: String?
          let creator_id: Int
          let community_id: Int
          let removed: Bool
          let locked: Bool
          let published: String
          let updated: String?
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

        struct PasswordResetRequest: Codable {
          let id: Int
          let user_id: Int
          let token_encrypted: String
          let published: String
        }

        struct ModRemovePost: Codable {
          let id: Int
          let mod_user_id: Int
          let post_id: Int
          let reason: String?
          let removed: Bool
          let when_: String
        }

        struct ModLockPost: Codable {
          let id: Int
          let mod_user_id: Int
          let post_id: Int
          let locked: Bool?
          let when_: String
        }

        struct ModStickyPost: Codable {
          let id: Int
          let mod_user_id: Int
          let post_id: Int
          let stickied: Bool
          let when_: String
        }

        struct ModRemoveComment: Codable {
          let id: Int
          let mod_user_id: Int
          let comment_id: Int
          let reason: String?
          let removed: Bool?
          let when_: String
        }

        struct ModRemoveCommunity: Codable {
          let id: Int
          let mod_user_id: Int
          let community_id: Int
          let reason: String?
          let removed: Bool?
          let expires: Bool?
          let when_: String
        }

        struct ModBanFromCommunity: Codable {
          let id: Int
          let mod_user_id: Int
          let other_user_id: Int
          let community_id: Int
          let reason: String?
          let banned: Bool?
          let expires: String?
          let when_: String
        }

        struct ModBan: Codable {
          let id: Int
          let mod_user_id: Int
          let other_user_id: Int
          let reason: String?
          let banned: Bool?
          let expires: String?
          let when_: String
        }

        struct ModAddCommunity: Codable {
          let id: Int
          let mod_user_id: Int
          let other_user_id: Int
          let community_id: Int
          let removed: Bool?
          let when_: String
        }

        struct ModAdd: Codable {
          let id: Int
          let mod_user_id: Int
          let other_user_id: Int
          let removed: Bool?
          let when_: String
        }

        struct CommunitySafe: Codable {
          let id: Int
          let name: String
          let title: String
          let description: String?
          let category_id: Int
          let creator_id: Int
          let removed: Bool
          let published: String
          let updated: String?
          let deleted: Bool
          let nsfw: Bool
          let actor_id: String
          let local: Bool
          let icon: String?
          let banner: String?
        }

        struct CommentReport: Codable {
          let id: Int
          let creator_id: Int
          let comment_id: Int
          let original_comment_text: String
          let reason: String
          let resolved: Bool
          let resolver_id: Int?
          let published: String
          let updated: String?
        }

        struct Comment: Codable {
          let id: Int
          let creator_id: Int
          let post_id: Int
          let parent_id: Int?
          let content: String
          let removed: Bool
          let read: Bool // Whether the recipient has read the comment or not
          let published: String
          let updated: String?
          let deleted: Bool
          let ap_id: String
          let local: Bool
        }

        struct Category: Codable {
          let id: Int
          let name: String
        }

        struct UserMention: Codable {
          let id: Int
          let recipient_id: Int
          let comment_id: Int
          let read: Bool
          let published: String
        }
    }
    
}
