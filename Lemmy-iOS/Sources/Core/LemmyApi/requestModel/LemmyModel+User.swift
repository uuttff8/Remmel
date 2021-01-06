//
//  LemmyApiStructs+User.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/13/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

extension LemmyModel {
    enum User {

        // MARK: - GetUserDetails
        struct GetUserDetailsRequest: Codable, Equatable {
            let userId: Int?
            let username: String?
            let sort: LemmySortType
            let page: Int?
            let limit: Int?
            let communityId: Int?
            let savedOnly: Bool
            let auth: String?

            enum CodingKeys: String, CodingKey {
                case userId = "user_id"
                case username, sort, page, limit
                case communityId = "community_id"
                case savedOnly = "saved_only"
                case auth
            }
        }

        struct GetUserDetailsResponse: Codable, Equatable {
            let user: UserView
            let follows: [CommunityFollowerView]
            let moderates: [CommunityModeratorView]
            let comments: [CommentView]
            let posts: [PostView]
        }

        // MARK: - SaveUserSettings
        struct SaveUserSettingsRequest: Codable, Equatable {
            let showNsfw: Bool
            let theme: String
            let defaultSortType: Int
            let defaultListingType: Int
            let lang: String
            let avatar: String?
            let banner: String?
            let preferredUsername: String?
            let email: String?
            let bio: String?
            let matrixUserId: String?
            let newPassword: String?
            let newPasswordVerify: String?
            let oldPassword: String?
            let showAvatars: Bool
            let sendNotificationsToEmail: Bool
            let auth: String

            enum CodingKeys: String, CodingKey {
                case showNsfw = "show_nsfw"
                case theme
                case defaultSortType = "default_sort_type"
                case defaultListingType = "default_listing_type"
                case lang, avatar, banner
                case preferredUsername = "preferred_username"
                case email, bio
                case matrixUserId = "matrix_user_id"
                case newPassword = "new_password"
                case newPasswordVerify = "new_password_verify"
                case oldPassword = "old_password"
                case showAvatars = "show_avatars"
                case sendNotificationsToEmail = "send_notifications_to_email"
                case auth
            }
        }

        struct SaveUserSettingsResponse: Codable, Equatable {
            let jwt: String
        }

        // MARK: - Get Replies / Inbox
        struct GetRepliesRequest: Codable, Equatable {
            let sort: LemmySortType
            let page: Int?
            let limit: Int?
            let unreadOnly: Bool
            let auth: String

            enum CodingKeys: String, CodingKey {
                case sort, page, limit
                case unreadOnly = "unread_only"
                case auth
            }
        }

        struct GetRepliesResponse: Codable, Equatable {
            let replies: [ReplyView]
        }

        // MARK: - GetUserMentions
        struct GetUserMentionsRequest: Codable, Equatable {
            let sort: LemmySortType
            let page: Int
            let limit: Int?
            let unreadOnly: Bool
            let auth: String

            enum CodingKeys: String, CodingKey {
                case sort, page, limit
                case unreadOnly = "unread_only"
                case auth
            }
        }

        struct GetUserMentionsResponse: Codable, Equatable {
            let mentions: [UserMentionView]
        }
        
        // MARK: - CreatePrivateMessage
        struct CreatePrivateMessageRequest: Codable, Equatable {
            let content: String
            let recipientId: Int
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case content
                case recipientId = "recipient_id"
                case auth
            }
        }
        
        struct CreatePrivateMessageResponse: Codable, Equatable {
            let message: PrivateMessageView
        }
    }
}
