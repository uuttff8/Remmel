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
        
        struct UserMentionView: Codable {
            let user_mention: LMModels.Source.UserMention
            let comment: LMModels.Source.Comment
            let creator: LMModels.Source.UserSafe
            let post: LMModels.Source.Post
            let community: LMModels.Source.CommunitySafe
            let recipient: LMModels.Source.UserSafe
            let counts: LMModels.Aggregates.CommentAggregates
            let creator_banned_from_community: Bool // Left Join to CommunityUserBan
            let subscribed: Bool // Left join to CommunityFollower
            let saved: Bool // Left join to CommentSaved
            let my_vote: Int? // Left join to CommentLi,
        }
        
        struct SiteView: Codable {
            let site: LMModels.Source.Site
            let creator: LMModels.Source.UserSafe
            let counts: LMModels.Aggregates.SiteAggregates
        }
        
        struct PrivateMessageView: Codable {
            let private_message: LMModels.Source.PrivateMessage
            let creator: LMModels.Source.UserSafe
            let recipient: LMModels.Source.UserSafe
        }
        
        struct PostView: Codable {
            let post: LMModels.Source.Post
            let creator: LMModels.Source.UserSafe
            let community: LMModels.Source.CommunitySafe
            let creator_banned_from_community: Bool // Left Join to CommunityUserBan
            let counts: LMModels.Aggregates.PostAggregates
            let subscribed: Bool // Left join to CommunityFollower
            let saved: Bool // Left join to PostSaved
            let read: Bool // Left join to PostRead
            let my_vote: Int? // Left join to PostLi,
        }
        
        struct PostReportView: Codable {
            let post_report: LMModels.Source.PostReport
            let post: LMModels.Source.Post
            let community: LMModels.Source.CommunitySafe
            let creator: LMModels.Source.UserSafe
            let post_creator: LMModels.Source.UserSafe
            let resolver: LMModels.Source.UserSafe?
        }
        
        struct CommentView: Codable {
            let comment: LMModels.Source.Comment
            let creator: LMModels.Source.UserSafe
            let recipient: LMModels.Source.UserSafe? // Left joins to comment and us,
            let post: LMModels.Source.Post
            let community: LMModels.Source.CommunitySafe
            let counts: LMModels.Aggregates.CommentAggregates
            let creator_banned_from_community: Bool // Left Join to CommunityUserBan
            let subscribed: Bool // Left join to CommunityFollower
            let saved: Bool // Left join to CommentSaved
            let my_vote: Int? // Left join to CommentLi,
        }
        
        struct CommentReportView: Codable {
            let comment_report: LMModels.Source.CommentReport
            let comment: LMModels.Source.Comment
            let post: LMModels.Source.Post
            let community: LMModels.Source.CommunitySafe
            let creator: LMModels.Source.UserSafe
            let comment_creator: LMModels.Source.UserSafe
            let resolver: LMModels.Source.UserSafe?
        }
        
        struct ModAddCommunityView: Codable {
            let mod_add_community: LMModels.Source.ModAddCommunity
            let moderator: LMModels.Source.UserSafe
            let community: LMModels.Source.CommunitySafe
            let modded_user: LMModels.Source.UserSafe
        }
        
        struct ModAddView: Codable {
            let mod_add: LMModels.Source.ModAdd
            let moderator: LMModels.Source.UserSafe
            let modded_user: LMModels.Source.UserSafe
        }
        
        struct ModBanFromCommunityView: Codable {
            let mod_ban_from_community: LMModels.Source.ModBanFromCommunity
            let moderator: LMModels.Source.UserSafe
            let community: LMModels.Source.CommunitySafe
            let banned_user: LMModels.Source.UserSafe
        }
        
        struct ModBanView: Codable {
            let mod_ban: LMModels.Source.ModBan
            let moderator: LMModels.Source.UserSafe
            let banned_user: LMModels.Source.UserSafe
        }
        
        struct ModLockPostView: Codable {
            let mod_lock_post: LMModels.Source.ModLockPost
            let moderator: LMModels.Source.UserSafe
            let post: LMModels.Source.Post
            let community: LMModels.Source.CommunitySafe
        }
        
        struct ModRemoveCommentView: Codable {
            let mod_remove_comment: LMModels.Source.ModRemoveComment
            let moderator: LMModels.Source.UserSafe
            let comment: LMModels.Source.Comment
            let commenter: LMModels.Source.UserSafe
            let post: LMModels.Source.Post
            let community: LMModels.Source.CommunitySafe
        }
        
        struct ModRemoveCommunityView: Codable {
            let mod_remove_community: LMModels.Source.ModRemoveCommunity
            let moderator: LMModels.Source.UserSafe
            let community: LMModels.Source.CommunitySafe
        }
        
        struct ModRemovePostView: Codable {
            let mod_remove_post: LMModels.Source.ModRemovePost
            let moderator: LMModels.Source.UserSafe
            let post: LMModels.Source.Post
            let community: LMModels.Source.CommunitySafe
        }
        
        struct ModStickyPostView: Codable {
            let mod_sticky_post: LMModels.Source.ModStickyPost
            let moderator: LMModels.Source.UserSafe
            let post: LMModels.Source.Post
            let community: LMModels.Source.CommunitySafe
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
        
        struct CommunityView: Codable {
            let community: LMModels.Source.CommunitySafe
            let creator: LMModels.Source.UserSafe
            let category: LMModels.Source.Category
            let subscribed: Bool
            let counts: LMModels.Aggregates.CommunityAggregates
        }
        
    }
}
