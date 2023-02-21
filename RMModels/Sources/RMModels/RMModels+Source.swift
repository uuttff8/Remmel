//
//  Source.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 15.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

public extension RMModels {
    
    enum Source {
        public struct LocalUserSettings: Identifiable, Codable, Hashable, Equatable {
            public let id: Int
            public let personId: Int
            public let email: String?
            public let showNsfw: Bool
            public let theme: String
            public let defaultSortType: RMModels.Others.SortType
            public let defaultListingType: RMModels.Others.ListingType
            public let interfaceLanguage: String
            public let showAvatars: Bool
            public let sendNotificationsToEmail: Bool
            public let validatorTime: String
            public let showBotAccounts: Bool?
            public let showScores: Bool?
            public let showReadPosts: Bool?
            public let showNewPostNotifs: Bool?
            public let emailVerified: Bool
            public let acceptedApplication: Bool
            
            enum CodingKeys: String, CodingKey {
                case id, personId = "person_id", email
                case showNsfw = "show_nsfw", theme
                case defaultSortType = "default_sort_type"
                case defaultListingType = "default_listing_type"
                case interfaceLanguage = "interface_language"
                case showAvatars = "show_avatars"
                case sendNotificationsToEmail = "send_notifications_to_email"
                case validatorTime = "validator_time"
                case showBotAccounts = "show_bot_accounts"
                case showScores = "show_scores"
                case showReadPosts = "show_read_posts"
                case showNewPostNotifs = "show_new_post_notifs"
                case emailVerified = "email_verified"
                case acceptedApplication = "accepted_application"
            }
        }

        public struct PersonSafe: Identifiable, Codable, Hashable, Equatable {
            public let id: Int
            public let name: String
            public let displayName: String?
            public let avatar: URL?
            public let banned: Bool
            public let published: Date
            public let updated: Date?
            public let actorId: URL
            public let bio: String?
            public let local: Bool
            public let banner: URL?
            public let deleted: Bool
            public let inboxUrl: URL
            public let sharedInboxURL: URL?
            public let admin: Bool
            public let matrixUserId: String?
            public let botAccount: Bool
            public let banExpires: String?
            public let instanceId: Int

            enum CodingKeys: String, CodingKey {
                case id, name
                case displayName = "display_name"
                case avatar, banned, published, updated
                case actorId = "actor_id"
                case bio, local, banner, deleted
                case inboxUrl = "inbox_url"
                case sharedInboxURL = "shared_inbox_url"
                case admin
                case matrixUserId = "matrix_user_id"
                case botAccount = "bot_account"
                case banExpires = "ban_expires"
                case instanceId = "instance_id"
            }
        }

        public struct Site: Identifiable, Codable {
            public let id: Int
            public let name: String
            public let sidebar: String?
            public let published: Date
            public let updated: Date
            public let icon: URL?
            public let banner: URL?
            public let description: String?
            public let actorId: String
            public let lastRefreshedAt: String
            public let inboxUrl: String
            public let publicKey: String
            public let instanceId: Int
            
            enum CodingKeys: String, CodingKey {
                case id
                case name, sidebar
                case published, updated
                case icon, banner, description
                case actorId = "actor_id"
                case lastRefreshedAt = "last_refreshed_at"
                case inboxUrl = "inbox_url"
                case publicKey = "public_key"
                case instanceId = "instance_id"
            }
        }
        
        public enum RegistrationMode: String, Codable {
            case closed = "closed"
            case requireApplication = "requireapplication"
            case Open = "open"
        }
        
        public struct LocalSite: Codable {
            public let id: Int
            public let siteId: Int
            public let siteSetup: Bool
            public let enableDownvotes: Bool
            public let registrationMode: RMModels.Source.RegistrationMode
            public let enableNsfw: Bool
            public let communityCreationAdminOnly: Bool
            public let requireEmailVerification: Bool
            public let applicationQuestion: String?
            public let privateInstance: Bool
            public let defaultTheme: String
            public let defaultPostListingType: String
            public let legalInformation: String?
            public let hideModlogModNames: Bool
            public let applicationEmailAdmins: Bool
            public let reportsEmailAdmins: Bool?
            public let slurFilterRegex: String?
            public let actorNameMaxLength: Int
            public let federationEnabled: Bool
            public let federationDebug: Bool
            public let federationWorkerCount: Int
            public let captchaEnabled: Bool
            public let captchaDifficulty: String
            public let published: Date
            public let updated: Date?

            enum CodingKeys: String, CodingKey {
                case id
                case siteId = "site_id"
                case siteSetup = "site_setup"
                case enableDownvotes = "enable_downvotes"
                case registrationMode = "registration_mode"
                case enableNsfw = "enable_nsfw"
                case communityCreationAdminOnly = "community_creation_admin_only"
                case requireEmailVerification = "require_email_verification"
                case applicationQuestion = "application_question"
                case privateInstance = "private_instance"
                case defaultTheme = "default_theme"
                case defaultPostListingType = "default_post_listing_type"
                case legalInformation = "legal_information"
                case hideModlogModNames = "hide_modlog_mod_names"
                case applicationEmailAdmins = "application_email_admins"
                case reportsEmailAdmins = "reports_email_admins"
                case slurFilterRegex = "slur_filter_regex"
                case actorNameMaxLength = "actor_name_max_length"
                case federationEnabled = "federation_enabled"
                case federationDebug = "federation_debug"
                case federationWorkerCount = "federation_worker_count"
                case captchaEnabled = "captcha_enabled"
                case captchaDifficulty = "captcha_difficulty"
                case published, updated
            }
        }
        
        public struct LocalSiteRateLimit: Codable {
            public let id: Int
            public let localSiteId: Int
            public let message: Int
            public let messagePerSecond: Int
            public let post: Int
            public let postPerSecond: Int
            public let register: Int
            public let registerPerSecond: Int
            public let image: Int
            public let imagePerSecond: Int
            public let comment: Int
            public let commentPerSecond: Int
            public let search: Int
            public let searchPerSecond: Int
            public let published: Date
            public let updated: Date?
            
            enum CodingKeys: String, CodingKey {
                case id
                case localSiteId = "local_site_id"
                case message
                case messagePerSecond = "message_per_second"
                case post
                case postPerSecond = "post_per_second"
                case register
                case registerPerSecond = "register_per_second"
                case image
                case imagePerSecond = "image_per_second"
                case comment
                case commentPerSecond = "comment_per_second"
                case search = "search"
                case searchPerSecond = "search_per_second"
                case published, updated
            }
        }

        public struct PrivateMessage: Identifiable, Codable {
            public let id: Int
            public let creatorId: Int
            public let recipientId: Int
            public let content: String
            public let deleted: Bool
            public let read: Bool
            public let published: Date
            public let updated: Date?
            public let apId: String
            public let local: Bool
            
            enum CodingKeys: String, CodingKey {
                case id
                case creatorId = "creator_id"
                case recipientId = "recipient_id"
                case content, deleted, read, published, updated
                case apId = "ap_id"
                case local
            }
        }
        
        public struct PostReport: Identifiable, Codable {
            public let id: Int
            public let creatorId: Int
            public let postId: Int
            public let originalPostName: String
            public let originalPostUrl: URL?
            public let originalPostBody: String
            public let reason: String
            public let resolved: Bool
            public let resolverId: Int?
            public let published: Date
            public let updated: String?
            
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
        
        public struct Post: Identifiable, Codable, Hashable, Equatable {
            public let id: Int
            public let name: String
            public let url: String? // sometimes may return image in base 64 encoding
            public let body: String?
            public let creatorId: Int
            public let communityId: Int
            public let removed: Bool
            public let locked: Bool
            public let published: Date
            public let updated: Date?
            public let deleted: Bool
            public let nsfw: Bool
            public let embedTitle: String?
            public let embedDescription: String?
            public let embedVideoUrl: String?
            public let thumbnailUrl: URL?
            public let apId: String
            public let local: Bool
            
            enum CodingKeys: String, CodingKey {
                case id
                case name, url, body, removed
                case locked, published, updated, deleted
                case nsfw
                case creatorId = "creator_id"
                case communityId = "community_id"
                case embedTitle = "embed_title"
                case embedDescription = "embed_description"
                case embedVideoUrl = "embed_video_url"
                case thumbnailUrl = "thumbnail_url"
                case apId = "ap_id"
                case local
            }
        }
        
        public struct PasswordResetRequest: Identifiable, Codable {
            public let id: Int
            public let localUserId: Int
            public let tokenEncrypted: String
            public let published: Date
            
            enum CodingKeys: String, CodingKey {
                case id
                case localUserId = "local_user_id"
                case tokenEncrypted = "token_encrypted"
                case published
            }
        }
        
        public struct ModRemovePost: Identifiable, Codable {
            public let id: Int
            public let modPersonId: Int
            public let postId: Int
            public let reason: String?
            public let removed: Bool
            public let when: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case modPersonId = "mod_person_id"
                case postId = "post_id"
                case reason, removed
                case when = "when_"
            }
        }
        
        public struct ModLockPost: Identifiable, Codable {
            public let id: Int
            public let modPersonId: Int
            public let postId: Int
            public let locked: Bool?
            public let when: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case modPersonId = "mod_person_id"
                case postId = "post_id"
                case locked
                case when = "when_"
            }
        }
        
        public struct ModFeaturePost: Identifiable, Codable {
            public let id: Int
            public let modPersonId: Int
            public let postId: Int
            public let featured: Bool
            public let isFeaturedCommunity: Bool
            public let when: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case modPersonId = "mod_person_id"
                case postId = "post_id"
                case featured
                case isFeaturedCommunity = "is_featured_community"
                case when = "when_"
            }
        }
        
        public struct ModRemoveComment: Identifiable, Codable {
            public let id: Int
            public let modPersonId: Int
            public let commentId: Int
            public let reason: String?
            public let removed: Bool?
            public let when: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case modPersonId = "mod_person_id"
                case commentId = "comment_id"
                case removed, reason
                case when = "when_"
            }
        }
        
        public struct ModRemoveCommunity: Identifiable, Codable {
            public let id: Int
            public let modPersonId: Int
            public let communityId: Int
            public let reason: String?
            public let removed: Bool?
            public let expires: Bool?
            public let when: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case modPersonId = "mod_person_id"
                case communityId = "community_id"
                case expires, removed, reason
                case when = "when_"
            }
        }
        
        public struct ModBanFromCommunity: Identifiable, Codable {
            public let id: Int
            public let modPersonId: Int
            public let otherPersonId: Int
            public let communityId: Int
            public let reason: String?
            public let banned: Bool?
            public let expires: String?
            public let when: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case modPersonId = "mod_person_id"
                case otherPersonId = "other_person_id"
                case communityId = "community_id"
                case expires, banned, reason
                case when = "when_"
            }
        }
        
        public struct ModBan: Identifiable, Codable {
            public let id: Int
            public let modPersonId: Int
            public let otherPersonId: Int
            public let reason: String?
            public let banned: Bool?
            public let expires: String?
            public let when: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case modPersonId = "mod_person_id"
                case otherPersonId = "other_person_id"
                case expires, banned, reason
                case when = "when_"
            }
        }
        
        public struct ModAddCommunity: Identifiable, Codable {
            public let id: Int
            public let modPersonId: Int
            public let otherPersonId: Int
            public let communityId: Int
            public let removed: Bool?
            public let when: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case modPersonId = "mod_person_id"
                case otherPersonId = "other_person_id"
                case communityId = "community_id"
                case removed
                case when = "when_"
            }
        }
        
        public struct ModTransferCommunity: Codable {
            public let id: Int
            public let modPersonId: Int
            public let otherPersonId: Int
            public let communityId: Int
            public let removed: Bool?
            public let when: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case modPersonId = "mod_person_id"
                case otherPersonId = "other_person_id"
                case communityId = "community_id"
                case removed
                case when = "when_"
            }
       }
        
        public struct ModAdd: Identifiable, Codable {
            public let id: Int
            public let modPersonId: Int
            public let otherPersonId: Int
            public let removed: Bool?
            public let when: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case modPersonId = "mod_person_id"
                case otherPersonId = "other_person_id"
                case removed
                case when = "when_"
            }
        }
        
        public struct CommunitySafe: Identifiable, Codable, Hashable, Equatable {
            public let id: Int
            public let name: String
            public let title: String
            public let description: String?
            public let removed: Bool
            public let published: Date
            public let updated: Date?
            public let deleted: Bool
            public let nsfw: Bool
            public let actorId: URL
            public let local: Bool
            public let icon: URL?
            public let banner: URL?
            public let hidden: Bool
            public let postingRestrictedToMods: Bool
            public let instanceId: Int
            
            enum CodingKeys: String, CodingKey {
                case id
                case name, title, description
                case removed, published, updated, deleted
                case nsfw
                case actorId = "actor_id"
                case local, icon, banner
                case hidden
                case postingRestrictedToMods = "posting_restricted_to_mods"
                case instanceId = "instance_id"
            }
        }
        
        public struct CommentReport: Identifiable, Codable {
            public let id: Int
            public let creatorId: Int
            public let commentId: Int
            public let originalCommentText: String
            public let reason: String
            public let resolved: Bool
            public let resolverId: Int?
            public let published: Date
            public let updated: String?
            
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
        
        public struct Comment: Identifiable, Codable, Hashable, Equatable {
            public let id: Int
            public let creatorId: Int
            public let postId: Int
            public let content: String
            public let removed: Bool
            public let published: Date
            public let updated: Date?
            public let deleted: Bool
            public let apId: String
            public let local: Bool
            public let path: String
            public let distinguished: Bool
            public let languageId: Int
            
            enum CodingKeys: String, CodingKey {
                case id
                case creatorId = "creator_id"
                case postId = "post_id"
                case content, removed
                case published, updated
                case deleted
                case apId = "ap_id"
                case local
                case path
                case distinguished
                case languageId = "language_id"
            }
        }
                
        public struct PersonMention: Identifiable, Codable {
            public let id: Int
            public let recipientId: Int
            public let commentId: Int
            public let read: Bool
            public let published: Date
            
            enum CodingKeys: String, CodingKey {
                case id
                case recipientId = "recipient_id"
                case commentId = "comment_id"
                case read, published
            }
        }
        
        public struct CommentReply: Codable {
            public let id: Int
            public let recipientId: Int
            public let commentId: Int
            public let read: Bool
            public let published: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case recipientId = "recipient_id"
                case commentId = "comment_id"
                case read, published
            }
        }
        
        public struct RegistrationApplication: Identifiable, Codable {
            public let id: Int
            public let localUserId: Int
            public let answer: Int
            public let adminId: Int?
            public let denyReason: String?
            public let published: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case localUserId = "local_user_id"
                case answer
                case adminId = "admin_id"
                case denyReason = "deny_reason"
                case published
            }
        }
        
        public struct Language: Codable {
            public let id: Int
            public let code: String
            public let name: String
        }
        
        public struct PrivateMessageReport: Codable {
            public let id: Int
            public let creatorId: Int
            public let privateMessageId: Int
            public let originalPmText: String
            public let reason: String
            public let resolved: Bool
            public let resolverId: Int?
            public let published: String
            public let updated: String?
            
            enum CodingKeys: String, CodingKey {
                case id
                case creatorId = "creator_id"
                case privateMessageId = "private_message_id"
                case originalPmText = "original_pm_text"
                case reason, resolved
                case resolverId = "resolver_id"
                case published, updated
            }
        }
        
        public struct Tagline: Codable {
            public let id: Int
            public let localSiteId: Int
            public let content: String
            public let published: Date
            public let updated: Date?
            
            enum CodingKeys: String, CodingKey {
                case id
                case localSiteId = "local_site_id"
                case content
                case published, updated
            }
        }
    }
}
