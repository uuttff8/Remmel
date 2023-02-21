//
//  RMModels+Views.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 15.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

public extension RMModels {
    enum Views {
        
        public struct PersonViewSafe: Codable {
            public let person: RMModels.Source.PersonSafe
            public let counts: RMModels.Aggregates.PersonAggregates
        }
        
        public struct PersonMentionView: Identifiable, Codable/*, VoteGettable*/ {
            
            public var id: Int {
                comment.id
            }
            
            public let personMention: RMModels.Source.PersonMention
            public var comment: RMModels.Source.Comment
            public let creator: RMModels.Source.PersonSafe
            public let post: RMModels.Source.Post
            public let community: RMModels.Source.CommunitySafe
            public let recipient: RMModels.Source.PersonSafe
            public let counts: RMModels.Aggregates.CommentAggregates
            public let creatorBannedFromCommunity: Bool
            public let subscribed: RMModels.Others.SubscribedType
            public let saved: Bool
            public let creatorBlocked: Bool
            public let myVote: Int?
            
            enum CodingKeys: String, CodingKey {
                case personMention = "person_mention"
                case comment, creator, post, community
                case recipient, counts
                case creatorBannedFromCommunity = "creator_banned_from_community"
                case subscribed, saved
                case creatorBlocked = "creator_blocked"
                case myVote = "my_vote"
            }
        }
        
        public struct LocalUserSettingsView: Codable {
            public let localUser: RMModels.Source.LocalUserSettings
            public let person: RMModels.Source.PersonSafe
            public let counts: RMModels.Aggregates.PersonAggregates
            
            enum CodingKeys: String, CodingKey {
                case localUser = "local_user"
                case person, counts
            }
        }
        
        public struct SiteView: Codable {
            public let site: RMModels.Source.Site
            public let localSite: RMModels.Source.LocalSite
            public let localSiteRateLimit: RMModels.Source.LocalSiteRateLimit
            public let taglines: [RMModels.Source.Tagline]?
            public let counts: RMModels.Aggregates.SiteAggregates
            
            enum CodingKeys: String, CodingKey {
                case site
                case localSite = "local_site"
                case localSiteRateLimit = "local_site_rate_limit"
                case taglines, counts
            }
        }
        
        public struct PrivateMessageView: Codable {
            public let privateMessage: RMModels.Source.PrivateMessage
            public let creator: RMModels.Source.PersonSafe
            public let recipient: RMModels.Source.PersonSafe
            
            enum CodingKeys: String, CodingKey {
                case privateMessage = "private_message"
                case creator, recipient
            }
        }
        
        public struct PostView: Identifiable, Codable/*, VoteGettable*/, Hashable, Equatable {
            // for uniquness in uitableviewdiffabledatasource
            public let uuid = UUID()
            
            public var id: Int {
                post.id
            }
            
            public let post: RMModels.Source.Post
            public let creator: RMModels.Source.PersonSafe
            public let community: RMModels.Source.CommunitySafe
            public let creatorBannedFromCommunity: Bool
            public var counts: RMModels.Aggregates.PostAggregates
            public let subscribed: RMModels.Others.SubscribedType
            public let saved: Bool
            public let read: Bool
            public let creatorBlocked: Bool
            public var myVote: Int?
            public let unreadComments: Int
            
            enum CodingKeys: String, CodingKey {
                case creator, post, community, counts
                case creatorBannedFromCommunity = "creator_banned_from_community"
                case subscribed, saved, read
                case creatorBlocked = "creator_blocked"
                case myVote = "my_vote"
                case unreadComments = "unread_comments"
            }
        }
        
        public struct PostReportView: Codable {
            public let postReport: RMModels.Source.PostReport
            public let post: RMModels.Source.Post
            public let community: RMModels.Source.CommunitySafe
            public let creator: RMModels.Source.PersonSafe
            public let postCreator: RMModels.Source.PersonSafe
            public let creatorBannedFromCommunity: Bool
            public let myVote: Int?
            public let counts: RMModels.Aggregates.PostAggregates
            public let resolver: RMModels.Source.PersonSafe?
            
            enum CodingKeys: String, CodingKey {
                case postReport = "post_report"
                case postCreator = "post_creator"
                case post, community, creator
                case creatorBannedFromCommunity = "creator_banned_from_community"
                case myVote = "my_vote"
                case counts
                case resolver
            }
        }
        
        public struct CommentView: Hashable, Equatable, Identifiable/*, VoteGettable*/, Codable {
            // for uniquness in uitableviewdiffabledatasource
            public let uuid = UUID()
            
            public var id: Int {
                comment.id
            }
            
            public let comment: RMModels.Source.Comment
            public let creator: RMModels.Source.PersonSafe
            public let recipient: RMModels.Source.PersonSafe?
            public let post: RMModels.Source.Post
            public let community: RMModels.Source.CommunitySafe
            public var counts: RMModels.Aggregates.CommentAggregates
            public let creatorBannedFromCommunity: Bool
            public let subscribed: RMModels.Others.SubscribedType
            public let saved: Bool
            public let creatorBlocked: Bool
            public var myVote: Int?
            
            enum CodingKeys: String, CodingKey {
                case comment, creator, recipient, post
                case community, counts
                case creatorBannedFromCommunity = "creator_banned_from_community"
                case subscribed, saved
                case creatorBlocked = "creator_blocked"
                case myVote = "my_vote"
            }
        }
        
        public struct CommentReplyView: Codable, Identifiable {
            public var id: Int {
                commentReply.id
            }
            
            public let commentReply: RMModels.Source.CommentReply
            public let comment: RMModels.Source.Comment
            public let creator: RMModels.Source.PersonSafe
            public let post: RMModels.Source.Post
            public let community: RMModels.Source.CommunitySafe
            public let recipient: RMModels.Source.PersonSafe
            public let counts: RMModels.Aggregates.CommentAggregates
            public let creatorBannedFromCommunity: Bool
            public let subscribed: RMModels.Others.SubscribedType
            public let saved: Bool
            public let creatorBlocked: Bool
            public let myVote: Int?
            
            enum CodingKeys: String, CodingKey {
                case commentReply = "comment_reply"
                case comment, creator, post
                case community, recipient, counts
                case creatorBannedFromCommunity = "creator_banned_from_community"
                case subscribed, saved
                case creatorBlocked = "creator_blocked"
                case myVote = "my_vote"
            }
        }
        
        public struct CommentReportView: Codable {
            public let commentReport: RMModels.Source.CommentReport
            public let comment: RMModels.Source.Comment
            public let post: RMModels.Source.Post
            public let community: RMModels.Source.CommunitySafe
            public let creator: RMModels.Source.PersonSafe
            public let commentCreator: RMModels.Source.PersonSafe
            public let counts: RMModels.Aggregates.CommentAggregates
            public let creatorBannedFromCommunity: Bool
            public let myVote: Int?
            public let resolver: RMModels.Source.PersonSafe?
            
            enum CodingKeys: String, CodingKey {
                case commentReport = "comment_report"
                case commentCreator = "comment_creator"
                case counts
                case post, comment, community, creator
                case creatorBannedFromCommunity = "creator_banned_from_community"
                case myVote = "my_vote"
                case resolver
            }
        }
        
        public struct ModAddCommunityView: Codable {
            public let modAddCommunity: RMModels.Source.ModAddCommunity
            public let moderator: RMModels.Source.PersonSafe?
            public let community: RMModels.Source.CommunitySafe
            public let moddedPerson: RMModels.Source.PersonSafe
            
            enum CodingKeys: String, CodingKey {
                case modAddCommunity = "mod_add_community"
                case moddedPerson = "modded_person"
                case moderator, community
            }
        }
        
        public struct ModTransferCommunityView: Codable {
            public let modTransferCommunity: RMModels.Source.ModTransferCommunity
            public let moderator: RMModels.Source.PersonSafe?
            public let community: RMModels.Source.CommunitySafe
            public let moddedPerson: RMModels.Source.PersonSafe
            
            enum CodingKeys: String, CodingKey {
                case modTransferCommunity = "mod_transfer_community"
                case moderator, community
                case moddedPerson = "modded_person"
            }
        }
        
        public struct ModAddView: Codable {
            public let modAdd: RMModels.Source.ModAdd
            public let moderator: RMModels.Source.PersonSafe?
            public let moddedPerson: RMModels.Source.PersonSafe
            
            enum CodingKeys: String, CodingKey {
                case modAdd = "mod_add"
                case moddedPerson = "modded_person"
                case moderator
            }
        }
        
        public struct ModBanFromCommunityView: Codable {
            public let modBanFromCommunity: RMModels.Source.ModBanFromCommunity
            public let moderator: RMModels.Source.PersonSafe?
            public let community: RMModels.Source.CommunitySafe
            public let bannedPerson: RMModels.Source.PersonSafe
            
            enum CodingKeys: String, CodingKey {
                case modBanFromCommunity = "mod_ban_from_community"
                case bannedPerson = "banned_person"
                case community, moderator
            }
        }
        
        public struct ModBanView: Codable {
            public let modBan: RMModels.Source.ModBan
            public let moderator: RMModels.Source.PersonSafe?
            public let bannedPerson: RMModels.Source.PersonSafe
            
            enum CodingKeys: String, CodingKey {
                case modBan = "modBan"
                case bannedPerson = "banned_person"
                case moderator
            }
        }
        
        public struct ModLockPostView: Codable {
            public let modLockPost: RMModels.Source.ModLockPost
            public let moderator: RMModels.Source.PersonSafe?
            public let post: RMModels.Source.Post
            public let community: RMModels.Source.CommunitySafe
            
            enum CodingKeys: String, CodingKey {
                case modLockPost = "mod_lock_post"
                case community, post, moderator
            }
        }
        
        public struct ModRemoveCommentView: Codable {
            public let modRemoveComment: RMModels.Source.ModRemoveComment
            public let moderator: RMModels.Source.PersonSafe?
            public let comment: RMModels.Source.Comment
            public let commenter: RMModels.Source.PersonSafe
            public let post: RMModels.Source.Post
            public let community: RMModels.Source.CommunitySafe
            
            enum CodingKeys: String, CodingKey {
                case modRemoveComment = "mod_remove_comment"
                case moderator, comment, commenter, post, community
            }
        }
        
        public struct ModRemoveCommunityView: Codable {
            public let modRemoveCommunity: RMModels.Source.ModRemoveCommunity
            public let moderator: RMModels.Source.PersonSafe?
            public let community: RMModels.Source.CommunitySafe
            
            enum CodingKeys: String, CodingKey {
                case modRemoveCommunity = "mod_remove_community"
                case community, moderator
            }
        }
        
        public struct ModRemovePostView: Codable {
            public let modRemovePost: RMModels.Source.ModRemovePost
            public let moderator: RMModels.Source.PersonSafe?
            public let post: RMModels.Source.Post
            public let community: RMModels.Source.CommunitySafe
            
            enum CodingKeys: String, CodingKey {
                case modRemovePost = "mod_remove_post"
                case community, moderator, post
            }
        }
        
        public struct ModFeaturePostView: Codable {
            public let modFeaturePost: RMModels.Source.ModFeaturePost
            public let moderator: RMModels.Source.PersonSafe?
            public let post: RMModels.Source.Post
            public let community: RMModels.Source.CommunitySafe
            
            enum CodingKeys: String, CodingKey {
                case modFeaturePost = "mod_feature_post"
                case community, moderator, post
            }
        }
        
        public struct CommunityFollowerView: Codable {
            public let community: RMModels.Source.CommunitySafe
            public let follower: RMModels.Source.PersonSafe
        }
        
        public struct CommunityBlockView: Codable {
            public let person: RMModels.Source.PersonSafe
            public let community: RMModels.Source.CommunitySafe
        }
        
        public struct CommunityModeratorView: Codable {
            public let community: RMModels.Source.CommunitySafe
            public let moderator: RMModels.Source.PersonSafe
        }
        
        public struct CommunityPersonBanView: Codable {
            public let community: RMModels.Source.CommunitySafe
            public let person: RMModels.Source.PersonSafe
        }
        
        public struct PersonBlockView: Codable {
            public let person: RMModels.Source.PersonSafe
            public let target: RMModels.Source.PersonSafe
        }
        
        public struct CommunityView: Identifiable, Codable {
            
            public var id: Int {
                community.id
            }
            
            public let community: RMModels.Source.CommunitySafe
            public let subscribed: RMModels.Others.SubscribedType
            public let blocked: Bool
            public let counts: RMModels.Aggregates.CommunityAggregates
        }
        
        public struct RegistrationApplicationView: Codable {
            public let registration_application: RMModels.Source.RegistrationApplication
            public let creator_local_user: RMModels.Source.LocalUserSettings
            public let creator: RMModels.Source.PersonSafe
            public let admin: RMModels.Source.PersonSafe?
        }
        
        public struct PrivateMessageReportView: Codable {
            public let privateMessageReport: RMModels.Source.PrivateMessageReport
            public let privateMessage: RMModels.Source.PrivateMessage
            public let privateMessageCreator: RMModels.Source.PersonSafe
            public let creator: RMModels.Source.PersonSafe
            public let resolver: RMModels.Source.PersonSafe?
            
            enum CodingKeys: String, CodingKey {
                case privateMessageReport = "private_message_report"
                case privateMessage = "private_message"
                case privateMessageCreator = "private_message_creator"
                case creator, resolver
            }
        }
    }
}

// legacy:
//extension RMModels.Views.PostView {
//    func getUrlDomain() -> String? {
//        let type = PostType.getPostType(from: self)
//        
//        guard type != .none, let url = post.url else {
//            return nil
//        }
//
//        return URL(string: url)?.host
//    }
//}
