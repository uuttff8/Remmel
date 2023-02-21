//
//  RMModels+Api.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 15.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

public extension RMModels.Api {
    enum Person {
        
        public struct Login: Codable {
            public let usernameOrEmail: String
            public let password: String
            
            public init(usernameOrEmail: String, password: String) {
                self.usernameOrEmail = usernameOrEmail
                self.password = password
            }
            
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
        public struct Register: Codable {
            public let username: String
            /**
             * Email is mandatory if email verification is enabled on the server
             */
            public let email: String?
            public let password: String
            public let passwordVerify: String
            public let showNsfw: Bool
            /**
             * Captcha is only checked if these are enabled in the server.
             */
            public let captchaUuid: String? // Only checked if these are enabled in the server
            public let captchaAnswer: String?
            public let honeypot: String?
            /**
             * An answer is mandatory if require application is enabled on the server
             */
            public let answer: String?
            
            public init(username: String, email: String?, password: String, passwordVerify: String, showNsfw: Bool, captchaUuid: String?, captchaAnswer: String?, honeypot: String?, answer: String?) {
                self.username = username
                self.email = email
                self.password = password
                self.passwordVerify = passwordVerify
                self.showNsfw = showNsfw
                self.captchaUuid = captchaUuid
                self.captchaAnswer = captchaAnswer
                self.honeypot = honeypot
                self.answer = answer
            }
            
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
        
        public struct GetCaptcha: Codable {
            public init() {}
        }
        
        public struct GetCaptchaResponse: Codable {
            public let ok: CaptchaResponse? // Will be undefined if captchas are disabled
        }
        
        public struct CaptchaResponse: Codable {
            public let png: String  // A Base64 encoded png
            public let wav: String  // A Base64 encoded wav file
            public let uuid: String // A UUID to match the one given on request.
        }
        
        public struct SaveUserSettings: Codable {
            public let showNsfw: Bool?
            public let theme: String? // Default 'browser'
            public let defaultSortType: Int? // The Sort types from above, zero indexed as a number
            public let defaultListingType: Int? // Post listing types are `All, Subscribed, Community`, number
            public let interfaceLanguage: String?
            public let avatar: String?
            public let banner: String?
            public let displayName: String? // The display name
            public let email: String?
            public let bio: String?
            public let matrixUserId: String?
            public let showAvatars: Bool?
            public let showScores: Bool?
            public let sendNotificationsToEmail: Bool?
            public let botAccount: Bool?
            public let showBotAccounts: Bool?
            public let showReadPosts: Bool?
            public let showNewPostNotifs: Bool?
            public let discussionLanguages: [Int]?
            public let auth: String
            
            public init(showNsfw: Bool?, theme: String?, defaultSortType: Int?, defaultListingType: Int?, interfaceLanguage: String?, avatar: String?, banner: String?, displayName: String?, email: String?, bio: String?, matrixUserId: String?, showAvatars: Bool?, showScores: Bool?, sendNotificationsToEmail: Bool?, botAccount: Bool?, showBotAccounts: Bool?, showReadPosts: Bool?, showNewPostNotifs: Bool?, discussionLanguages: [Int]?, auth: String) {
                self.showNsfw = showNsfw
                self.theme = theme
                self.defaultSortType = defaultSortType
                self.defaultListingType = defaultListingType
                self.interfaceLanguage = interfaceLanguage
                self.avatar = avatar
                self.banner = banner
                self.displayName = displayName
                self.email = email
                self.bio = bio
                self.matrixUserId = matrixUserId
                self.showAvatars = showAvatars
                self.showScores = showScores
                self.sendNotificationsToEmail = sendNotificationsToEmail
                self.botAccount = botAccount
                self.showBotAccounts = showBotAccounts
                self.showReadPosts = showReadPosts
                self.showNewPostNotifs = showNewPostNotifs
                self.discussionLanguages = discussionLanguages
                self.auth = auth
            }
            
            enum CodingKeys: String, CodingKey {
                case showNsfw = "show_nsfw"
                case theme
                case defaultSortType = "default_sort_type"
                case defaultListingType = "default_listing_type"
                case interfaceLanguage = "interface_language"
                case avatar, banner
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
                case discussionLanguages = "discussion_languages"
                case auth
            }
        }
        
        public struct ChangePassword: Codable {
            public let newPassword: String
            public let newPasswordVerify: String
            public let oldPassword: String
            public let auth: String
            
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
        public struct LoginResponse: Codable {
            /**
             * This is None in response to `Register` if email verification is enabled, or the server requires registration applications.
             */
            public let jwt: String?
            public let verifyEmailSent: Bool
            public let registrationCreated: Bool
            
            enum CodingKeys: String, CodingKey {
                case jwt
                case verifyEmailSent = "verify_email_sent"
                case registrationCreated = "registration_created"
            }
            
        }
        
        public struct GetPersonDetails: Codable {
            let personId: Int?
            /**
             * To get details for a federated user, use `person@instance.tld`.
             */
            public let username: String?
            public let sort: RMModels.Others.SortType?
            public let page: Int?
            public let limit: Int?
            public let communityId: Int?
            public let savedOnly: Bool?
            public let auth: String?
            
            public init(personId: Int?, username: String?, sort: RMModels.Others.SortType?, page: Int?, limit: Int?, communityId: Int?, savedOnly: Bool?, auth: String?) {
                self.personId = personId
                self.username = username
                self.sort = sort
                self.page = page
                self.limit = limit
                self.communityId = communityId
                self.savedOnly = savedOnly
                self.auth = auth
            }
            
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
        
        public struct GetPersonDetailsResponse: Codable {
            public let personView: RMModels.Views.PersonViewSafe
            public let comments: [RMModels.Views.CommentView]
            public let posts: [RMModels.Views.PostView]
            public let moderates: [RMModels.Views.CommunityModeratorView]
            
            enum CodingKeys: String, CodingKey {
                case personView = "person_view"
                case comments
                case posts
                case moderates
            }
        }

        public struct MarkAllAsRead: Codable {
            public let auth: String
        }
        
        public struct GetRepliesResponse: Codable {
            public let replies: [RMModels.Views.CommentReplyView]
        }
        
        public struct GetPersonMentionsResponse: Codable {
            public let mentions: [RMModels.Views.PersonMentionView]
        }
                
        public struct AddAdmin: Codable {
            public let personId: Int
            public let added: Bool
            public let auth: String
            
            enum CodingKeys: String, CodingKey {
                case personId = "person_id"
                case added
                case auth
            }
        }
        
        public struct AddAdminResponse: Codable {
            public let admins: [RMModels.Views.PersonViewSafe]
        }
        
        public struct BanPerson: Codable {
            public let personId: Int
            public let ban: Bool
            public let removeData: Bool? // Removes/Restores their comments, posts, and communities
            public let reason: String?
            /**
            * The expire time in Unix seconds
            */
            public let expires: Int?
            public let auth: String
            
            enum CodingKeys: String, CodingKey {
                case personId = "person_id"
                case ban
                case removeData = "remove_data"
                case reason
                case expires
                case auth
            }
        }
        
        public struct BanPersonResponse: Codable {
            public let personView: RMModels.Views.PersonViewSafe
            public let banned: Bool
            
            enum CodingKeys: String, CodingKey {
                case personView = "person_view"
                case banned
            }
        }
        
        public struct GetReplies: Codable {
            public let sort: RMModels.Others.CommentSortType?
            public let page: Int?
            public let limit: Int?
            public let unreadOnly: Bool?
            public let auth: String
            
            public init(sort: RMModels.Others.CommentSortType?, page: Int?, limit: Int?, unreadOnly: Bool?, auth: String) {
                self.sort = sort
                self.page = page
                self.limit = limit
                self.unreadOnly = unreadOnly
                self.auth = auth
            }
            
            enum CodingKeys: String, CodingKey {
                case sort
                case page
                case limit
                case unreadOnly = "unread_only"
                case auth
            }
        }
        
        public struct GetPersonMentions: Codable {
            public let sort: RMModels.Others.CommentSortType?
            public let page: Int?
            public let limit: Int?
            public let unreadOnly: Bool?
            public let auth: String
            
            public init(sort: RMModels.Others.CommentSortType?, page: Int?, limit: Int?, unreadOnly: Bool?, auth: String) {
                self.sort = sort
                self.page = page
                self.limit = limit
                self.unreadOnly = unreadOnly
                self.auth = auth
            }
            
            enum CodingKeys: String, CodingKey {
                case sort
                case page
                case limit
                case unreadOnly = "unread_only"
                case auth
            }
        }
        
        public struct MarkPersonMentionAsRead: Codable {
            public let personMentionId: Int
            public let read: Bool
            public let auth: String
            
            enum CodingKeys: String, CodingKey {
                case personMentionId = "person_mention_id"
                case read
                case auth
            }
        }
        
        public struct PersonMentionResponse: Codable {
            public let personMentionView: RMModels.Views.PersonMentionView
            
            enum CodingKeys: String, CodingKey {
                case personMentionView = "person_mention_view"
            }
        }
        
        public struct MarkCommentReplyAsRead: Codable {
            public let commentReplyId: Int
            public let read: Bool
            public let auth: String
            
            enum CodingKeys: String, CodingKey {
                case commentReplyId = "comment_reply_id"
                case read, auth
            }
        }
        
        public struct CommentReplyResponse: Codable {
            public let commentReplyView: RMModels.Views.CommentReplyView
            
            enum CodingKeys: String, CodingKey {
                case commentReplyView = "comment_reply_view"
            }
        }
        
        /**
         * Permanently deletes your posts and comments
         */
        public struct DeleteAccount: Codable {
            public let password: String
            public let auth: String
        }
        
        public struct DeleteAccountResponse: Codable {}
        
        struct PasswordReset: Codable {
            public let email: String
        }
        
        public struct PasswordResetResponse: Codable {}
        
        public struct PasswordChange: Codable {
            public let token: String
            public let password: String
            public let passwordVerify: String
            
            enum CodingKeys: String, CodingKey {
                case token
                case password
                case passwordVerify = "password_verify"
            }
        }
        
        public struct CreatePrivateMessage: Codable {
            public let content: String
            public let recipientId: Int
            public let auth: String
            
            public init(content: String, recipientId: Int, auth: String) {
                self.content = content
                self.recipientId = recipientId
                self.auth = auth
            }
            
            enum CodingKeys: String, CodingKey {
                case content
                case recipientId = "recipient_id"
                case auth
            }
        }
        
        public struct EditPrivateMessage: Codable {
            public let privateMessageId: Int
            public let content: String
            public let auth: String
            
            enum CodingKeys: String, CodingKey {
                case privateMessageId = "private_message_id"
                case content
                case auth
            }
        }
        
        public struct DeletePrivateMessage: Codable {
            public let privateMessageId: Int
            public let deleted: Bool
            public let auth: String
            
            enum CodingKeys: String, CodingKey {
                case privateMessageId = "private_message_id"
                case deleted
                case auth
            }
        }
        
        public struct MarkPrivateMessageAsRead: Codable {
            public let privateMessageId: Int
            public let read: Bool
            public let auth: Bool
            
            enum CodingKeys: String, CodingKey {
                case privateMessageId = "private_message_id"
                case read
                case auth
            }
        }
        
        public struct GetPrivateMessages: Codable {
            public let unreadOnly: Bool?
            public let page: Int?
            public let limit: Int?
            public let auth: String
            
            public init(unreadOnly: Bool?, page: Int?, limit: Int?, auth: String) {
                self.unreadOnly = unreadOnly
                self.page = page
                self.limit = limit
                self.auth = auth
            }
            
            enum CodingKeys: String, CodingKey {
                case unreadOnly = "unread_only"
                case page
                case limit
                case auth
            }
        }
        
        public struct PrivateMessagesResponse: Codable {
            public let privateMessages: [RMModels.Views.PrivateMessageView]
            
            enum CodingKeys: String, CodingKey {
                case privateMessages = "private_messages"
            }
        }
        
        public struct PrivateMessageResponse: Codable {
            public let privateMessageView: RMModels.Views.PrivateMessageView
            
            enum CodingKeys: String, CodingKey {
                case privateMessageView = "private_message_view"
            }
        }
        
        public struct CreatePrivateMessageReport: Codable {
            public let privateMessageId: Int
            public let reason: String
            public let auth: String
            
            enum CodingKeys: String, CodingKey {
                case privateMessageId = "private_message_id"
                case reason, auth
            }
        }
        
        public struct PrivateMessageReportResponse: Codable {
            public let privateMessageReportView: RMModels.Views.PrivateMessageReportView
            
            enum CodingKeys: String, CodingKey {
                case privateMessageReportView = "private_message_report_view"
            }
        }
        
        public struct ResolvePrivateMessageReport: Codable {
            public let reportId: Int
            public let resolved: Bool
            public let auth: String
            
            enum CodingKeys: String, CodingKey {
                case reportId = "report_id"
                case resolved, auth
            }
        }
        
        public struct ListPrivateMessageReports: Codable {
            public let page: Int
            public let limit: Int
            /// Only shows the unresolved reports
            public let unresolvedOnly: Bool?
            public let auth: String
            
            enum CodingKeys: String, CodingKey {
                case page, limit
                case unresolvedOnly = "unresolved_only"
                case auth
            }
        }
        
        public struct ListPrivateMessageReportsResponse: Codable {
            public let privateMessageReports: [RMModels.Views.PrivateMessageReportView]
            
            enum CodingKeys: String, CodingKey {
                case privateMessageReports = "private_message_reports"
            }
        }
        
        public struct GetReportCount: Codable {
            /**
            * If a community is supplied, returns the report count for only that community, otherwise returns the report count for all communities the user moderates.
            */
            public let communityId: Int?
            public let auth: String
        }
        
        struct GetReportCountResponse: Codable {
            public let communityId: Int?
            public let commentReports: Int
            public let postReports: Int
            public let privateMessageReports: Int?
            
            enum CodingKeys: String, CodingKey {
                case communityId = "community_id"
                case commentReports = "comment_reports"
                case postReports = "post_reports"
                case privateMessageReports = "private_message_reports"
            }
        }
        
        public struct GetUnreadCount: Codable {
            public let auth: String
        }

        public struct GetUnreadCountResponse: Codable {
            public let replies: Int
            public let mentions: Int
            public let privateMessages: Int
            
            enum CodingKeys: String, CodingKey {
                case replies, mentions
                case privateMessages = "private_messages"
            }
        }

        public struct VerifyEmail: Codable {
            public let token: String
        }
        
        public struct VerifyEmailResponse: Codable {}

        public struct BlockPerson: Codable {
            public let personId: Int
            public let block: Bool
            public let auth: String
            
            enum CodingKeys: String, CodingKey {
                case personId = "person_id"
                case block, auth
            }
        }
        
        public struct BlockPersonResponse: Codable {
            public let personView: RMModels.Views.PersonViewSafe
            public let blocked: Bool
            
            enum CodingKeys: String, CodingKey {
                case personView = "person_view"
                case blocked
            }
        }
        
        public struct GetBannedPersons: Codable {
            public let auth: String
        }
        
        public struct BannedPersonsResponse: Codable {
            public let banned: [RMModels.Views.PersonViewSafe]
        }
    }
}
