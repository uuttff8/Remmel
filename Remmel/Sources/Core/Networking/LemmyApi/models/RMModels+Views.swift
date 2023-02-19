//
//  LMModels+Views.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 15.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

extension RMModels {
    enum Views {
        
        struct PersonViewSafe: Codable {
            let person: RMModels.Source.PersonSafe
            let counts: RMModels.Aggregates.PersonAggregates
        }
        
        struct PersonMentionView: Identifiable, Codable, VoteGettable {
            
            var id: Int {
                comment.id
            }
            
            let personMention: RMModels.Source.PersonMention
            var comment: RMModels.Source.Comment
            let creator: RMModels.Source.PersonSafe
            let post: RMModels.Source.Post
            let community: RMModels.Source.CommunitySafe
            let recipient: RMModels.Source.PersonSafe
            let counts: RMModels.Aggregates.CommentAggregates
            let creatorBannedFromCommunity: Bool
            let subscribed: Bool
            let saved: Bool
            let creatorBlocked: Bool
            let myVote: Int?
            
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
        
        struct LocalUserSettingsView: Codable {
            let localUser: RMModels.Source.LocalUserSettings
            let person: RMModels.Source.PersonSafe
            let counts: RMModels.Aggregates.PersonAggregates
            
            enum CodingKeys: String, CodingKey {
                case localUser = "local_user"
                case person, counts
            }
        }
        
        struct SiteView: Codable {
            let site: RMModels.Source.Site
            let counts: RMModels.Aggregates.SiteAggregates
        }
        
        struct PrivateMessageView: Codable {
            let privateMessage: RMModels.Source.PrivateMessage
            let creator: RMModels.Source.PersonSafe
            let recipient: RMModels.Source.PersonSafe
            
            enum CodingKeys: String, CodingKey {
                case privateMessage = "private_message"
                case creator, recipient
            }
        }
        
        struct PostView: Identifiable, Codable, VoteGettable, Hashable, Equatable {
            // for uniquness in uitableviewdiffabledatasource
            let uuid = UUID()
            
            var id: Int {
                post.id
            }
            
            let post: RMModels.Source.Post
            let creator: RMModels.Source.PersonSafe
            let community: RMModels.Source.CommunitySafe
            let creatorBannedFromCommunity: Bool
            var counts: RMModels.Aggregates.PostAggregates
            let subscribed: Bool
            let saved: Bool
            let read: Bool
            let creatorBlocked: Bool
            var myVote: Int?
            
            enum CodingKeys: String, CodingKey {
                case creator, post, community, counts
                case creatorBannedFromCommunity = "creator_banned_from_community"
                case subscribed, saved, read
                case creatorBlocked = "creator_blocked"
                case myVote = "my_vote"
                
            }
        }
        
        struct PostReportView: Codable {
            let postReport: RMModels.Source.PostReport
            let post: RMModels.Source.Post
            let community: RMModels.Source.CommunitySafe
            let creator: RMModels.Source.PersonSafe
            let postCreator: RMModels.Source.PersonSafe
            let creatorBannedFromCommunity: Bool
            let myVote: Int?
            let counts: RMModels.Aggregates.PostAggregates
            let resolver: RMModels.Source.PersonSafe?
            
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
        
        struct CommentView: Hashable, Equatable, Identifiable, VoteGettable, Codable {
            // for uniquness in uitableviewdiffabledatasource
            let uuid = UUID()
            
            var id: Int {
                comment.id
            }
            
            let comment: RMModels.Source.Comment
            let creator: RMModels.Source.PersonSafe
            let recipient: RMModels.Source.PersonSafe?
            let post: RMModels.Source.Post
            let community: RMModels.Source.CommunitySafe
            var counts: RMModels.Aggregates.CommentAggregates
            let creatorBannedFromCommunity: Bool
            let subscribed: Bool
            let saved: Bool
            let creatorBlocked: Bool
            var myVote: Int?
            
            enum CodingKeys: String, CodingKey {
                case comment, creator, recipient, post
                case community, counts
                case creatorBannedFromCommunity = "creator_banned_from_community"
                case subscribed, saved
                case creatorBlocked = "creator_blocked"
                case myVote = "my_vote"
            }
        }
        
        struct CommentReportView: Codable {
            let commentReport: RMModels.Source.CommentReport
            let comment: RMModels.Source.Comment
            let post: RMModels.Source.Post
            let community: RMModels.Source.CommunitySafe
            let creator: RMModels.Source.PersonSafe
            let commentCreator: RMModels.Source.PersonSafe
            let counts: RMModels.Aggregates.CommentAggregates
            let creatorBannedFromCommunity: Bool
            let myVote: Int?
            let resolver: RMModels.Source.PersonSafe?
            
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
        
        struct ModAddCommunityView: Codable {
            let modAddCommunity: RMModels.Source.ModAddCommunity
            let moderator: RMModels.Source.PersonSafe
            let community: RMModels.Source.CommunitySafe
            let moddedPerson: RMModels.Source.PersonSafe
            
            enum CodingKeys: String, CodingKey {
                case modAddCommunity = "mod_add_community"
                case moddedPerson = "modded_person"
                case moderator, community
            }
        }
        
        struct ModTransferCommunityView: Codable {
            let modTransferCommunity: RMModels.Source.ModTransferCommunity
            let moderator: RMModels.Source.PersonSafe
            let community: RMModels.Source.CommunitySafe
            let moddedPerson: RMModels.Source.PersonSafe
            
            enum CodingKeys: String, CodingKey {
                case modTransferCommunity = "mod_transfer_community"
                case moderator, community
                case moddedPerson = "modded_person"
            }
       }
        
        struct ModAddView: Codable {
            let modAdd: RMModels.Source.ModAdd
            let moderator: RMModels.Source.PersonSafe
            let moddedPerson: RMModels.Source.PersonSafe
            
            enum CodingKeys: String, CodingKey {
                case modAdd = "mod_add"
                case moddedPerson = "modded_person"
                case moderator
            }
        }
        
        struct ModBanFromCommunityView: Codable {
            let modBanFromCommunity: RMModels.Source.ModBanFromCommunity
            let moderator: RMModels.Source.PersonSafe
            let community: RMModels.Source.CommunitySafe
            let bannedPerson: RMModels.Source.PersonSafe
            
            enum CodingKeys: String, CodingKey {
                case modBanFromCommunity = "mod_ban_from_community"
                case bannedPerson = "banned_person"
                case community, moderator
            }
        }
        
        struct ModBanView: Codable {
            let modBan: RMModels.Source.ModBan
            let moderator: RMModels.Source.PersonSafe
            let bannedPerson: RMModels.Source.PersonSafe
            
            enum CodingKeys: String, CodingKey {
                case modBan = "modBan"
                case bannedPerson = "banned_person"
                case moderator
            }
        }
        
        struct ModLockPostView: Codable {
            let modLockPost: RMModels.Source.ModLockPost
            let moderator: RMModels.Source.PersonSafe
            let post: RMModels.Source.Post
            let community: RMModels.Source.CommunitySafe
            
            enum CodingKeys: String, CodingKey {
                case modLockPost = "mod_lock_post"
                case community, post, moderator
            }
        }
        
        struct ModRemoveCommentView: Codable {
            let modRemoveComment: RMModels.Source.ModRemoveComment
            let moderator: RMModels.Source.PersonSafe
            let comment: RMModels.Source.Comment
            let commenter: RMModels.Source.PersonSafe
            let post: RMModels.Source.Post
            let community: RMModels.Source.CommunitySafe
            
            enum CodingKeys: String, CodingKey {
                case modRemoveComment = "mod_remove_comment"
                case moderator, comment, commenter, post, community
            }
        }
        
        struct ModRemoveCommunityView: Codable {
            let modRemoveCommunity: RMModels.Source.ModRemoveCommunity
            let moderator: RMModels.Source.PersonSafe
            let community: RMModels.Source.CommunitySafe
            
            enum CodingKeys: String, CodingKey {
                case modRemoveCommunity = "mod_remove_community"
                case community, moderator
            }
        }
        
        struct ModRemovePostView: Codable {
            let modRemovePost: RMModels.Source.ModRemovePost
            let moderator: RMModels.Source.PersonSafe
            let post: RMModels.Source.Post
            let community: RMModels.Source.CommunitySafe
            
            enum CodingKeys: String, CodingKey {
                case modRemovePost = "mod_remove_post"
                case community, moderator, post
            }
        }
        
        struct ModStickyPostView: Codable {
            let modStickyPost: RMModels.Source.ModStickyPost
            let moderator: RMModels.Source.PersonSafe
            let post: RMModels.Source.Post
            let community: RMModels.Source.CommunitySafe
            
            enum CodingKeys: String, CodingKey {
                case modStickyPost = "mod_sticky_post"
                case community, moderator, post
            }
        }
        
        struct CommunityFollowerView: Codable {
            let community: RMModels.Source.CommunitySafe
            let follower: RMModels.Source.PersonSafe
        }
        
        struct CommunityBlockView: Codable {
            let person: RMModels.Source.PersonSafe
            let community: RMModels.Source.CommunitySafe
       }
        
        struct CommunityModeratorView: Codable {
            let community: RMModels.Source.CommunitySafe
            let moderator: RMModels.Source.PersonSafe
        }
        
        struct CommunityPersonBanView: Codable {
            let community: RMModels.Source.CommunitySafe
            let person: RMModels.Source.PersonSafe
        }
        
        struct PersonBlockView: Codable {
            let person: RMModels.Source.PersonSafe
            let target: RMModels.Source.PersonSafe
       }
        
        struct CommunityView: Identifiable, Codable {
            
            var id: Int {
                community.id
            }
            
            let community: RMModels.Source.CommunitySafe
            let subscribed: Bool
            let blocked: Bool
            let counts: RMModels.Aggregates.CommunityAggregates
        }
        
        struct RegistrationApplicationView: Codable {
            let registration_application: RMModels.Source.RegistrationApplication
            let creator_local_user: RMModels.Source.LocalUserSettings
            let creator: RMModels.Source.PersonSafe
            let admin: RMModels.Source.PersonSafe?
       }
    }
}

// legacy:
extension RMModels.Views.PostView {
    func getUrlDomain() -> String? {
        let type = PostType.getPostType(from: self)
        
        guard type != .none, let url = post.url else {
            return nil
        }

        return URL(string: url)?.host
    }
}
