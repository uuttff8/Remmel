//
//  LMModels+Api.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 15.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

extension LMModels.Api {
    enum Person {
        
        struct Login: Codable {
            let usernameOrEmail: String
            let password: String
            
            enum CodingKeys: String, CodingKey {
                case usernameOrEmail = "username_or_email"
                case password
            }
        }
        
        struct Register: Codable {
            let username: String
            let email: String?
            let password: String
            let passwordVerify: String
            let showNsfw: Bool
            let captchaUuid: String? // Only checked if these are enabled in the server
            let captchaAnswer: String?
            
            enum CodingKeys: String, CodingKey {
                case username, email
                case password
                case passwordVerify = "password_verify"
                case showNsfw = "show_nsfw"
                case captchaUuid = "captcha_uuid"
                case captchaAnswer = "captcha_answer"
            }
        }
        
        struct GetCaptcha: Codable {}
        
        struct GetCaptchaResponse: Codable {
            let ok: CaptchaResponse? // Will be undefined if captchas are disabled
        }
        
        struct CaptchaResponse: Codable {
            let png: String // A Base64 encoded png
            let wav: String // A Base64 encoded wav aud,
            let uuid: String
        }
        
        struct SaveUserSettings: Codable {
            let showNsfw: Bool
            let theme: String // Default 'browser'
            let defaultSortType: Int // The Sort types from above, zero indexed as a number
            let defaultListingType: Int // Post listing types are `All, Subscribed, Community`, number
            let lang: String
            let avatar: String?
            let banner: String?
            let preferredUsername: String? // The display name
            let email: String?
            let bio: String?
            let matrixUserId: String?
            let newPassword: String? // If setting a new password, you need all 3 password fields
            let newPasswordVerify: String?
            let oldPassword: String? // SHOULD BE NON NULL BUT WE CANT UPDATE USER DATA WITHOUT PASSWORD 
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
        
        /**
         * The `jwt` string should be stored and used anywhere `auth` is called for.
         */
        struct LoginResponse: Codable {
            let jwt: String
        }
        
        /**
        * `username` can only be used for local users. To get details for a federated user, pass `personId` instead.
        */
        struct GetPersonDetails: Codable {
            let personId: Int?
            let username: String?
            let sort: LMModels.Others.SortType
            let page: Int?
            let limit: Int?
            let communityId: Int?
            let savedOnly: Bool
            let auth: String?
            
            enum CodingKeys: String, CodingKey {
                case personId = "person_id"
                case username
                case sort
                case page
                case limit
                case communityId = "community_id"
                case savedOnly = "saved_only"
                case auth
            }
        }
        
        struct GetPersonDetailsResponse: Codable {
            let personView: LMModels.Views.PersonViewSafe
            let follows: [LMModels.Views.CommunityFollowerView]
            let moderates: [LMModels.Views.CommunityModeratorView]
            let comments: [LMModels.Views.CommentView]
            let posts: [LMModels.Views.PostView]
            
            enum CodingKeys: String, CodingKey {
                case personView = "person_view"
                case follows
                case moderates
                case comments
                case posts
            }
        }
        
        struct GetRepliesResponse: Codable {
            let replies: [LMModels.Views.CommentView]
        }
        
        struct GetPersonMentionsResponse: Codable {
            let mentions: [LMModels.Views.PersonMentionView]
        }
        
        struct MarkAllAsRead: Codable {
            let auth: String
        }
        
        struct AddAdmin: Codable {
            let personId: Int
            let added: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case personId = "person_id"
                case added
                case auth
            }
        }
        
        struct AddAdminResponse: Codable {
            let admins: [LMModels.Views.PersonViewSafe]
        }
        
        struct BanPerson: Codable {
            let personId: Int
            let ban: Bool
            let removeData: Bool // Removes/Restores their comments, posts, and communities
            let reason: String?
            let expires: Int?
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case personId = "person_id"
                case ban
                case removeData = "remove_data"
                case reason
                case expires
                case auth
            }
        }
        
        struct BanPersonResponse: Codable {
            let personView: LMModels.Views.PersonViewSafe
            let banned: Bool
            
            enum CodingKeys: String, CodingKey {
                case personView = "person_view"
                case banned
            }
        }
        
        struct GetReplies: Codable {
            let sort: LMModels.Others.SortType
            let page: Int?
            let limit: Int?
            let unreadOnly: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case sort
                case page
                case limit
                case unreadOnly = "unread_only"
                case auth
            }
        }
        
        struct GetPersonMentions: Codable {
            let sort: LMModels.Others.SortType
            let page: Int?
            let limit: Int?
            let unreadOnly: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case sort
                case page
                case limit
                case unreadOnly = "unread_only"
                case auth
            }
        }
        
        struct MarkPersonMentionAsRead: Codable {
            let personMentionId: Int
            let read: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case personMentionId = "person_mention_id"
                case read
                case auth
            }
        }
        
        struct PersonMentionResponse: Codable {
            let personMentionView: LMModels.Views.PersonMentionView
            
            enum CodingKeys: String, CodingKey {
                case personMentionView = "person_mention_view"
            }
        }
        
        /**
        * Permanently deletes your posts and comments
        */
        struct DeleteAccount: Codable {
            let password: String
            let auth: String
        }
        
        struct PasswordReset: Codable {
            let email: String
        }
        
        struct PasswordResetResponse: Codable {}
        
        struct PasswordChange: Codable {
            let token: String
            let password: String
            let passwordVerify: String
            
            enum CodingKeys: String, CodingKey {
                case token
                case password
                case passwordVerify = "password_verify"
            }
        }
        
        struct CreatePrivateMessage: Codable {
            let content: String
            let recipientId: Int
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case content
                case recipientId = "recipient_id"
                case auth
            }
        }
        
        struct EditPrivateMessage: Codable {
            let privateMessageId: Int
            let content: String
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case privateMessageId = "private_message_id"
                case content
                case auth
            }
        }
        
        struct DeletePrivateMessage: Codable {
            let privateMessageId: Int
            let deleted: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case privateMessageId = "private_message_id"
                case deleted
                case auth
            }
        }
        
        struct MarkPrivateMessageAsRead: Codable {
            let privateMessageId: Int
            let read: Bool
            let auth: Bool
            
            enum CodingKeys: String, CodingKey {
                case privateMessageId = "private_message_id"
                case read
                case auth
            }
        }
        
        struct GetPrivateMessages: Codable {
            let unreadOnly: Bool
            let page: Int?
            let limit: Int?
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case unreadOnly = "unread_only"
                case page
                case limit
                case auth
            }
        }
        
        struct PrivateMessagesResponse: Codable {
            let privateMessages: [LMModels.Views.PrivateMessageView]
            
            enum CodingKeys: String, CodingKey {
                case privateMessages = "private_messages"
            }
        }
        
        struct PrivateMessageResponse: Codable {
            let privateMessageView: LMModels.Views.PrivateMessageView
            
            enum CodingKeys: String, CodingKey {
                case privateMessageView = "private_message_view"
            }
        }
                
        /**
         * If a community is supplied, returns the report count for only that community,
         * otherwise returns the report count for all communities the user moderates.
         */
        struct GetReportCount: Codable {
            let community: Int?
            let auth: String
        }
        
        struct GetReportCountResponse: Codable {
            let community: Int?
            let commentReports: Int
            let postReports: Int
            
            enum CodingKeys: String, CodingKey {
                case community
                case commentReports = "comment_reports"
                case postReports = "post_reports"
            }
        }
        
    }
}
