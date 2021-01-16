//
//  LMModels+Views.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 15.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

extension LMModels {
    enum Views {
        
        struct UserViewSafe: Codable {
            let user: LMModels.Source.UserSafe
            let counts: LMModels.Aggregates.UserAggregates
        }
        
        struct UserViewDangerous: Codable {
            let user: LMModels.Source.User_
            let counts: LMModels.Aggregates.UserAggregates
        }
        
        struct UserMentionView: Identifiable, Codable, VoteGettable {
            
            var id: Int {
                comment.id
            }
            
            let userMention: LMModels.Source.UserMention
            let comment: LMModels.Source.Comment
            let creator: LMModels.Source.UserSafe
            let post: LMModels.Source.Post
            let community: LMModels.Source.CommunitySafe
            let recipient: LMModels.Source.UserSafe
            let counts: LMModels.Aggregates.CommentAggregates
            let creatorBannedFromCommunity: Bool // Left Join to CommunityUserBan
            let subscribed: Bool // Left join to CommunityFollower
            let saved: Bool // Left join to CommentSaved
            let myVote: Int? // Left join to CommentLi,
            
            enum CodingKeys: String, CodingKey {
                case userMention = "user_mention"
                case comment, creator, post, community
                case recipient, counts
                case creatorBannedFromCommunity = "creator_banned_from_community"
                case subscribed, saved
                case myVote = "my_vote"
            }
        }
        
        struct SiteView: Codable {
            let site: LMModels.Source.Site
            let creator: LMModels.Source.UserSafe
            let counts: LMModels.Aggregates.SiteAggregates
        }
        
        struct PrivateMessageView: Codable {
            let privateMessage: LMModels.Source.PrivateMessage
            let creator: LMModels.Source.UserSafe
            let recipient: LMModels.Source.UserSafe
            
            enum CodingKeys: String, CodingKey {
                case privateMessage = "private_message"
                case creator, recipient
            }
        }
        
        struct PostView: Identifiable, Codable, VoteGettable, Hashable, Equatable {
            
            var id: Int {
                self.post.id
            }
            
            let post: LMModels.Source.Post
            let creator: LMModels.Source.UserSafe
            let community: LMModels.Source.CommunitySafe
            let creatorBannedFromCommunity: Bool // Left Join to CommunityUserBan
            let counts: LMModels.Aggregates.PostAggregates
            let subscribed: Bool // Left join to CommunityFollower
            let saved: Bool // Left join to PostSaved
            let read: Bool // Left join to PostRead
            let myVote: Int? // Left join to PostLi,
            
            enum CodingKeys: String, CodingKey {
                case creator, post, community, counts
                case creatorBannedFromCommunity = "creator_banned_from_community"
                case subscribed, saved, read
                case myVote = "my_vote"
            }
        }
        
        struct PostReportView: Codable {
            let postReport: LMModels.Source.PostReport
            let post: LMModels.Source.Post
            let community: LMModels.Source.CommunitySafe
            let creator: LMModels.Source.UserSafe
            let postCreator: LMModels.Source.UserSafe
            let resolver: LMModels.Source.UserSafe?
            
            enum CodingKeys: String, CodingKey {
                case postReport = "post_report"
                case postCreator = "post_creator"
                case post, community, creator, resolver
            }
        }
        
        struct CommentView: Hashable, Equatable, Identifiable, VoteGettable, Codable {
            
            var id: Int {
                comment.id
            }
            
            let comment: LMModels.Source.Comment
            let creator: LMModels.Source.UserSafe
            let recipient: LMModels.Source.UserSafe? // Left joins to comment and us,
            let post: LMModels.Source.Post
            let community: LMModels.Source.CommunitySafe
            let counts: LMModels.Aggregates.CommentAggregates
            let creatorBannedFromCommunity: Bool // Left Join to CommunityUserBan
            let subscribed: Bool // Left join to CommunityFollower
            let saved: Bool // Left join to CommentSaved
            let myVote: Int? // Left join to CommentLi,
            
            enum CodingKeys: String, CodingKey {
                case comment, creator, recipient, post
                case community, counts
                case creatorBannedFromCommunity = "creator_banned_from_community"
                case subscribed, saved
                case myVote = "my_vote"
            }
        }
        
        struct CommentReportView: Codable {
            let commentReport: LMModels.Source.CommentReport
            let comment: LMModels.Source.Comment
            let post: LMModels.Source.Post
            let community: LMModels.Source.CommunitySafe
            let creator: LMModels.Source.UserSafe
            let commentCreator: LMModels.Source.UserSafe
            let resolver: LMModels.Source.UserSafe?
            
            enum CodingKeys: String, CodingKey {
                case commentReport = "post_report"
                case commentCreator = "post_creator"
                case post, comment, community, creator, resolver
            }
        }
        
        struct ModAddCommunityView: Codable {
            let modAddCommunity: LMModels.Source.ModAddCommunity
            let moderator: LMModels.Source.UserSafe
            let community: LMModels.Source.CommunitySafe
            let moddedUser: LMModels.Source.UserSafe
            
            enum CodingKeys: String, CodingKey {
                case modAddCommunity = "mod_add_community"
                case moddedUser = "modded_user"
                case moderator, community
            }
        }
        
        struct ModAddView: Codable {
            let modAdd: LMModels.Source.ModAdd
            let moderator: LMModels.Source.UserSafe
            let moddedUser: LMModels.Source.UserSafe
            
            enum CodingKeys: String, CodingKey {
                case modAdd = "mod_add"
                case moddedUser = "modded_user"
                case moderator
            }
        }
        
        struct ModBanFromCommunityView: Codable {
            let modBanFromCommunity: LMModels.Source.ModBanFromCommunity
            let moderator: LMModels.Source.UserSafe
            let community: LMModels.Source.CommunitySafe
            let bannedUser: LMModels.Source.UserSafe
            
            enum CodingKeys: String, CodingKey {
                case modBanFromCommunity = "mod_ban_from_community"
                case bannedUser = "bannedUser"
                case community, moderator
            }
        }
        
        struct ModBanView: Codable {
            let modBan: LMModels.Source.ModBan
            let moderator: LMModels.Source.UserSafe
            let bannedUser: LMModels.Source.UserSafe
            
            enum CodingKeys: String, CodingKey {
                case modBan = "modBan"
                case bannedUser = "banned_user"
                case moderator
            }
        }
        
        struct ModLockPostView: Codable {
            let modLockPost: LMModels.Source.ModLockPost
            let moderator: LMModels.Source.UserSafe
            let post: LMModels.Source.Post
            let community: LMModels.Source.CommunitySafe
            
            enum CodingKeys: String, CodingKey {
                case modLockPost = "mod_lock_post"
                case community, post, moderator
            }
        }
        
        struct ModRemoveCommentView: Codable {
            let modRemoveComment: LMModels.Source.ModRemoveComment
            let moderator: LMModels.Source.UserSafe
            let comment: LMModels.Source.Comment
            let commenter: LMModels.Source.UserSafe
            let post: LMModels.Source.Post
            let community: LMModels.Source.CommunitySafe
            
            enum CodingKeys: String, CodingKey {
                case modRemoveComment = "mod_remove_comment"
                case moderator, comment, commenter, post, community
            }
        }
        
        struct ModRemoveCommunityView: Codable {
            let modRemoveCommunity: LMModels.Source.ModRemoveCommunity
            let moderator: LMModels.Source.UserSafe
            let community: LMModels.Source.CommunitySafe
            
            enum CodingKeys: String, CodingKey {
                case modRemoveCommunity = "mod_remove_community"
                case community, moderator
            }
        }
        
        struct ModRemovePostView: Codable {
            let modRemovePost: LMModels.Source.ModRemovePost
            let moderator: LMModels.Source.UserSafe
            let post: LMModels.Source.Post
            let community: LMModels.Source.CommunitySafe
            
            enum CodingKeys: String, CodingKey {
                case modRemovePost = "mod_remove_post"
                case community, moderator, post
            }
        }
        
        struct ModStickyPostView: Codable {
            let modStickyPost: LMModels.Source.ModStickyPost
            let moderator: LMModels.Source.UserSafe
            let post: LMModels.Source.Post
            let community: LMModels.Source.CommunitySafe
            
            enum CodingKeys: String, CodingKey {
                case modStickyPost = "mod_sticky_post"
                case community, moderator, post
            }
        }
        
        struct CommunityFollowerView: Codable {
            let community: LMModels.Source.CommunitySafe
            let follower: LMModels.Source.UserSafe
        }
        
        struct CommunityModeratorView: Codable {
            let community: LMModels.Source.CommunitySafe
            let moderator: LMModels.Source.UserSafe
        }
        
        struct CommunityUserBanView: Codable {
            let community: LMModels.Source.CommunitySafe
            let user: LMModels.Source.UserSafe
        }
        
        struct CommunityView: Identifiable, Codable {
            
            var id: Int {
                community.id
            }
            
            let community: LMModels.Source.CommunitySafe
            let creator: LMModels.Source.UserSafe
            let category: LMModels.Source.Category
            let subscribed: Bool
            let counts: LMModels.Aggregates.CommunityAggregates
        }
        
    }
}

// legacy:

extension LMModels.Views.PostView {
    func getUrlDomain() -> String? {
        let type = PostType.getPostType(from: self)
        
        guard !(.none == type) else { return nil }
        guard let urlStr = self.post.url,
              let urlDomain = URL(string: urlStr)
              else { return nil }
        
        return urlDomain.host
    }
}
