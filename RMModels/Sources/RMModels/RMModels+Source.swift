//
//  Source.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 15.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

extension RMModels {
    
    enum Source {
        struct LocalUserSettings: Identifiable, Codable, Hashable, Equatable {
            let id: Int
            let personId: Int
            let email: String?
            let showNsfw: Bool
            let theme: String
            let defaultSortType: RMModels.Others.SortType
            let defaultListingType: RMModels.Others.ListingType
            let interfaceLanguage: String
            let showAvatars: Bool
            let sendNotificationsToEmail: Bool
            let validatorTime: String
            let showBotAccounts: Bool?
            let showScores: Bool?
            let showReadPosts: Bool?
            let showNewPostNotifs: Bool?
            let emailVerified: Bool
            let acceptedApplication: Bool
            
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

        struct PersonSafe: Identifiable, Codable, Hashable, Equatable {
            let id: Int
            let name: String
            let displayName: String?
            let avatar: URL?
            let banned: Bool
            let published: Date
            let updated: Date?
            let actorId: URL
            let bio: String?
            let local: Bool
            let banner: URL?
            let deleted: Bool
            let inboxUrl: URL
            let sharedInboxURL: URL?
            let admin: Bool
            let matrixUserId: String?
            let botAccount: Bool
            let banExpires: String?
            let instanceId: Int

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

        struct Site: Identifiable, Codable {
            let id: Int
            let name: String
            let sidebar: String?
            let published: Date
            let updated: Date
            let icon: URL?
            let banner: URL?
            let description: String?
            let actorId: String
            let lastRefreshedAt: String
            let inboxUrl: String
            let publicKey: String
            let instanceId: Int
            
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
        
        enum RegistrationMode: String, Codable {
            case closed = "closed"
            case requireApplication = "requireapplication"
            case Open = "open"
        }
        
        struct LocalSite: Codable {
            let id: Int
            let siteId: Int
            let siteSetup: Bool
            let enableDownvotes: Bool
            let registrationMode: RMModels.Source.RegistrationMode
            let enableNsfw: Bool
            let communityCreationAdminOnly: Bool
            let requireEmailVerification: Bool
            let applicationQuestion: String?
            let privateInstance: Bool
            let defaultTheme: String
            let defaultPostListingType: String
            let legalInformation: String?
            let hideModlogModNames: Bool
            let applicationEmailAdmins: Bool
            let reportsEmailAdmins: Bool
            let slurFilterRegex: String?
            let actorNameMaxLength: Int
            let federationEnabled: Bool
            let federationDebug: Bool
            let federationWorkerCount: Int
            let captchaEnabled: Bool
            let captchaDifficulty: String
            let published: Date
            let updated: Date?

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
        
        struct LocalSiteRateLimit: Codable {
            let id: Int
            let localSiteId: Int
            let message: Int
            let messagePerSecond: Int
            let post: Int
            let postPerSecond: Int
            let register: Int
            let registerPerSecond: Int
            let image: Int
            let imagePerSecond: Int
            let comment: Int
            let commentPerSecond: Int
            let search: Int
            let searchPerSecond: Int
            let published: Date
            let updated: Date?
            
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
            let originalPostUrl: URL?
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
            let url: String? // sometimes may return image in base 64 encoding
            let body: String?
            let creatorId: Int
            let communityId: Int
            let removed: Bool
            let locked: Bool
            let published: Date
            let updated: Date?
            let deleted: Bool
            let nsfw: Bool
            let embedTitle: String?
            let embedDescription: String?
            let embedVideoUrl: String?
            let thumbnailUrl: URL?
            let apId: String
            let local: Bool
            
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
        
        struct PasswordResetRequest: Identifiable, Codable {
            let id: Int
            let localUserId: Int
            let tokenEncrypted: String
            let published: Date
            
            enum CodingKeys: String, CodingKey {
                case id
                case localUserId = "local_user_id"
                case tokenEncrypted = "token_encrypted"
                case published
            }
        }
        
        struct ModRemovePost: Identifiable, Codable {
            let id: Int
            let modPersonId: Int
            let postId: Int
            let reason: String?
            let removed: Bool
            let when: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case modPersonId = "mod_person_id"
                case postId = "post_id"
                case reason, removed
                case when = "when_"
            }
        }
        
        struct ModLockPost: Identifiable, Codable {
            let id: Int
            let modPersonId: Int
            let postId: Int
            let locked: Bool?
            let when: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case modPersonId = "mod_person_id"
                case postId = "post_id"
                case locked
                case when = "when_"
            }
        }
        
        struct ModFeaturePost: Identifiable, Codable {
            let id: Int
            let modPersonId: Int
            let postId: Int
            let featured: Bool
            let isFeaturedCommunity: Bool
            let when: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case modPersonId = "mod_person_id"
                case postId = "post_id"
                case featured
                case isFeaturedCommunity = "is_featured_community"
                case when = "when_"
            }
        }
        
        struct ModRemoveComment: Identifiable, Codable {
            let id: Int
            let modPersonId: Int
            let commentId: Int
            let reason: String?
            let removed: Bool?
            let when: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case modPersonId = "mod_person_id"
                case commentId = "comment_id"
                case removed, reason
                case when = "when_"
            }
        }
        
        struct ModRemoveCommunity: Identifiable, Codable {
            let id: Int
            let modPersonId: Int
            let communityId: Int
            let reason: String?
            let removed: Bool?
            let expires: Bool?
            let when: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case modPersonId = "mod_person_id"
                case communityId = "community_id"
                case expires, removed, reason
                case when = "when_"
            }
        }
        
        struct ModBanFromCommunity: Identifiable, Codable {
            let id: Int
            let modPersonId: Int
            let otherPersonId: Int
            let communityId: Int
            let reason: String?
            let banned: Bool?
            let expires: String?
            let when: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case modPersonId = "mod_person_id"
                case otherPersonId = "other_person_id"
                case communityId = "community_id"
                case expires, banned, reason
                case when = "when_"
            }
        }
        
        struct ModBan: Identifiable, Codable {
            let id: Int
            let modPersonId: Int
            let otherPersonId: Int
            let reason: String?
            let banned: Bool?
            let expires: String?
            let when: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case modPersonId = "mod_person_id"
                case otherPersonId = "other_person_id"
                case expires, banned, reason
                case when = "when_"
            }
        }
        
        struct ModAddCommunity: Identifiable, Codable {
            let id: Int
            let modPersonId: Int
            let otherPersonId: Int
            let communityId: Int
            let removed: Bool?
            let when: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case modPersonId = "mod_person_id"
                case otherPersonId = "other_person_id"
                case communityId = "community_id"
                case removed
                case when = "when_"
            }
        }
        
        struct ModTransferCommunity: Codable {
            let id: Int
            let modPersonId: Int
            let otherPersonId: Int
            let communityId: Int
            let removed: Bool?
            let when: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case modPersonId = "mod_person_id"
                case otherPersonId = "other_person_id"
                case communityId = "community_id"
                case removed
                case when = "when_"
            }
       }
        
        struct ModAdd: Identifiable, Codable {
            let id: Int
            let modPersonId: Int
            let otherPersonId: Int
            let removed: Bool?
            let when: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case modPersonId = "mod_person_id"
                case otherPersonId = "other_person_id"
                case removed
                case when = "when_"
            }
        }
        
        struct CommunitySafe: Identifiable, Codable, Hashable, Equatable {
            let id: Int
            let name: String
            let title: String
            let description: String?
            let removed: Bool
            let published: Date
            let updated: Date?
            let deleted: Bool
            let nsfw: Bool
            let actorId: URL
            let local: Bool
            let icon: URL?
            let banner: URL?
            let hidden: Bool
            let postingRestrictedToMods: Bool
            let instanceId: Int
            
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
            let content: String
            let removed: Bool
            let published: Date
            let updated: Date?
            let deleted: Bool
            let apId: String
            let local: Bool
            let path: String
            let distinguished: Bool
            let languageId: Int
            
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
                
        struct PersonMention: Identifiable, Codable {
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
        
        struct CommentReply: Codable {
            let id: Int
            let recipientId: Int
            let commentId: Int
            let read: Bool
            let published: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case recipientId = "recipient_id"
                case commentId = "comment_id"
                case read, published
            }
        }
        
        struct RegistrationApplication: Identifiable, Codable {
            let id: Int
            let localUserId: Int
            let answer: Int
            let adminId: Int?
            let denyReason: String?
            let published: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case localUserId = "local_user_id"
                case answer
                case adminId = "admin_id"
                case denyReason = "deny_reason"
                case published
            }
        }
        
        struct Language: Codable {
            let id: Int
            let code: String
            let name: String
        }
        
        struct PrivateMessageReport: Codable {
            let id: Int
            let creatorId: Int
            let privateMessageId: Int
            let originalPmText: String
            let reason: String
            let resolved: Bool
            let resolverId: Int?
            let published: String
            let updated: String?
            
            
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
        
        struct Tagline: Codable {
            let id: Int
            let localSiteId: Int
            let content: String
            let published: Date
            let updated: Date?
            
            enum CodingKeys: String, CodingKey {
                case id
                case localSiteId = "local_site_id"
                case content
                case published, updated
            }
        }
    }
}
