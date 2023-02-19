//
//  LMModels+Api.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 15.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

extension RMModels.Api {
    enum Person {
        
        struct Login: Codable {
            let usernameOrEmail: String
            let password: String
            
            enum CodingKeys: String, CodingKey {
                case usernameOrEmail = "username_or_email"
                case password
            }
        }
        
        /**
         * Register a new user.
         *
         * Only the first user to register will be able to be the admin.
         */
        struct Register: Codable {
            let username: String
            /**
             * Email is mandatory if email verification is enabled on the server
             */
            let email: String?
            let password: String
            let passwordVerify: String
            let showNsfw: Bool
            /**
             * Captcha is only checked if these are enabled in the server.
             */
            let captchaUuid: String? // Only checked if these are enabled in the server
            let captchaAnswer: String?
            let honeypot: String?
            /**
             * An answer is mandatory if require application is enabled on the server
             */
            let answer: String?
            
            enum CodingKeys: String, CodingKey {
                case username, email
                case password
                case passwordVerify = "password_verify"
                case showNsfw = "show_nsfw"
                case captchaUuid = "captcha_uuid"
                case captchaAnswer = "captcha_answer"
                case honeypot, answer
            }
        }
        
        struct GetCaptcha: Codable {}
        
        struct GetCaptchaResponse: Codable {
            let ok: CaptchaResponse? // Will be undefined if captchas are disabled
        }
        
        struct CaptchaResponse: Codable {
            let png: String  // A Base64 encoded png
            let wav: String  // A Base64 encoded wav file
            let uuid: String // A UUID to match the one given on request.
        }
        
        struct SaveUserSettings: Codable {
            let showNsfw: Bool?
            let theme: String? // Default 'browser'
            let defaultSortType: Int? // The Sort types from above, zero indexed as a number
            let defaultListingType: Int? // Post listing types are `All, Subscribed, Community`, number
            let lang: String?
            let avatar: String?
            let banner: String?
            let displayName: String? // The display name
            let email: String?
            let bio: String?
            let matrixUserId: String?
            let showAvatars: Bool?
            let showScores: Bool?
            let sendNotificationsToEmail: Bool?
            let botAccount: Bool?
            let showBotAccounts: Bool?
            let showReadPosts: Bool?
            let showNewPostNotifs: Bool?
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case showNsfw = "show_nsfw"
                case theme
                case defaultSortType = "default_sort_type"
                case defaultListingType = "default_listing_type"
                case lang, avatar, banner
                case displayName = "display_name"
                case email, bio
                case matrixUserId = "matrix_user_id"
                case showAvatars = "show_avatars"
                case showReadPosts = "show_read_posts"
                case sendNotificationsToEmail = "send_notifications_to_email"
                case showScores = "show_scores"
                case botAccount = "bot_account"
                case showBotAccounts = "show_bot_accounts"
                case showNewPostNotifs = "show_new_post_notifs"
                case auth
            }
        }
        
        struct ChangePassword: Codable {
            let newPassword: String
            let newPasswordVerify: String
            let oldPassword: String
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case newPassword = "new_password"
                case newPasswordVerify = "new_password_verify"
                case oldPassword = "old_password"
                case auth
            }
        }
        
        /**
         * The `jwt` string should be stored and used anywhere `auth` is called for.
         */
        struct LoginResponse: Codable {
            /**
             * This is None in response to `Register` if email verification is enabled, or the server requires registration applications.
             */
            let jwt: String?
            let verifyEmailSent: Bool
            let registrationCreated: Bool
            
            enum CodingKeys: String, CodingKey {
                case jwt
                case verifyEmailSent = "verify_email_sent"
                case registrationCreated = "registration_created"
            }
            
        }
        
        struct GetPersonDetails: Codable {
            let personId: Int?
            /**
             * To get details for a federated user, use `person@instance.tld`.
             */
            let username: String?
            let sort: RMModels.Others.SortType?
            let page: Int?
            let limit: Int?
            let communityId: Int?
            let savedOnly: Bool?
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
            let personView: RMModels.Views.PersonViewSafe
            let comments: [RMModels.Views.CommentView]
            let posts: [RMModels.Views.PostView]
            let moderates: [RMModels.Views.CommunityModeratorView]
            
            enum CodingKeys: String, CodingKey {
                case personView = "person_view"
                case comments
                case posts
                case moderates
            }
        }

        struct MarkAllAsRead: Codable {
            let auth: String
        }
        
        struct GetRepliesResponse: Codable {
            let replies: [RMModels.Views.CommentView]
        }
        
        struct GetPersonMentionsResponse: Codable {
            let mentions: [RMModels.Views.PersonMentionView]
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
            let admins: [RMModels.Views.PersonViewSafe]
        }
        
        struct BanPerson: Codable {
            let personId: Int
            let ban: Bool
            let removeData: Bool? // Removes/Restores their comments, posts, and communities
            let reason: String?
            /**
            * The expire time in Unix seconds
            */
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
            let personView: RMModels.Views.PersonViewSafe
            let banned: Bool
            
            enum CodingKeys: String, CodingKey {
                case personView = "person_view"
                case banned
            }
        }
        
        struct GetReplies: Codable {
            let sort: RMModels.Others.SortType?
            let page: Int?
            let limit: Int?
            let unreadOnly: Bool?
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
            let sort: RMModels.Others.SortType?
            let page: Int?
            let limit: Int?
            let unreadOnly: Bool?
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
            let personMentionView: RMModels.Views.PersonMentionView
            
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
        
        struct DeleteAccountResponse: Codable {}
        
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
            let unreadOnly: Bool?
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
            let privateMessages: [RMModels.Views.PrivateMessageView]
            
            enum CodingKeys: String, CodingKey {
                case privateMessages = "private_messages"
            }
        }
        
        struct PrivateMessageResponse: Codable {
            let privateMessageView: RMModels.Views.PrivateMessageView
            
            enum CodingKeys: String, CodingKey {
                case privateMessageView = "private_message_view"
            }
        }
        
        struct GetReportCount: Codable {
            /**
            * If a community is supplied, returns the report count for only that community, otherwise returns the report count for all communities the user moderates.
            */
            let communityId: Int?
            let auth: String
        }
        
        struct GetReportCountResponse: Codable {
            let communityId: Int?
            let commentReports: Int
            let postReports: Int
            
            enum CodingKeys: String, CodingKey {
                case communityId = "community_id"
                case commentReports = "comment_reports"
                case postReports = "post_reports"
            }
        }
        
        struct GetUnreadCount: Codable {
            let auth: String
        }

        struct GetUnreadCountResponse: Codable {
            let replies: Int
            let mentions: Int
            let privateMessages: Int
            
            enum CodingKeys: String, CodingKey {
                case replies, mentions
                case privateMessages = "private_messages"
            }
        }

        struct VerifyEmail: Codable {
            let token: String
        }
        
        struct VerifyEmailResponse: Codable {}

        struct BlockPerson: Codable {
            let personId: Int
            let block: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case personId = "person_id"
                case block, auth
            }
        }
        
        struct BlockPersonResponse: Codable {
            let personView: RMModels.Views.PersonViewSafe
            let blocked: Bool
            
            enum CodingKeys: String, CodingKey {
                case personView = "person_view"
                case blocked
            }
        }
        
        struct GetBannedPersons: Codable {
            let auth: String
        }
        
        struct BannedPersonsResponse: Codable {
            let banned: [RMModels.Views.PersonViewSafe]
        }
    }
}
