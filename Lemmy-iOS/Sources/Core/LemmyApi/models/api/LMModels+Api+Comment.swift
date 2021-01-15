//
//  LMModels+Api+Comment.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 15.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

extension LMModels.Api {
    enum Comment {
        
        struct CreateComment: Codable {
            let content: String
            let parentId: Int?
            let postId: Int
            let formId: String?
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case content
                case parentId = "parent_id"
                case postId = "post_id"
                case formId = "form_id"
                case auth
            }
        }
        
        struct EditComment: Codable {
            let content: String
            let editId: Int
            let formId: String?
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case content
                case editId = "edit_id"
                case formId = "form_id"
                case auth
            }
        }
        
        struct DeleteComment {
            let editId: Int
            let deleted: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case editId = "edit_id"
                case deleted, auth
            }
        }
        
        struct RemoveComment {
            let editId: Int
            let removed: Bool
            let reason: String?
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case editId = "edit_id"
                case removed, reason, auth
            }
        }
        
        struct MarkCommentAsRead {
            let commentId: Int
            let read: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case commentId = "comment_id"
                case read, auth
            }
        }
        
        struct SaveComment {
            let comment_id: Int
            let save: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case commentId = "comment_id"
                case save, auth
            }
        }
        
        struct CommentResponse {
            let commentView: LMModels.Views.CommentView
            let recipientIds: [Int]  // TODO another way to do this? Maybe a UserMention belongs to Comment
            let formId: Int  // An optional front end ID, to tell which is coming ba,
            
            enum CodingKeys: String, CodingKey {
                case commentView = "comment_view"
                case recipientIds = "recipient_ids"
                case formId = "form_id"
            }
        }
        
        struct CreateCommentLike {
            let commentId: Int
            let score: Int
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case commentId = "comment_id"
                case score
                case auth
            }
        }
        
        struct GetComments {
            let type: LemmyListingType
            let sort: LemmySortType
            let page: Int?
            let limit: Int?
            let communityId: Int?
            let communityName: String?
            let auth: String?
            
            enum CodingKeys: String, CodingKey {
                case type = "type_"
                case sort, page, limit, auth
                case communityId = "community_id"
                case communityName = "community_name"
            }
        }
        
        struct GetCommentsResponse {
            let comments: [LMModels.Views.CommentView]
        }
        
        struct CreateCommentReport {
            let comment_id: Int
            let reason: String
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case commentId = "comment_id"
                case reason, auth
            }
        }
        
        struct CreateCommentReportResponse {
            let success: Bool
        }
        
        struct ResolveCommentReport {
            let reportId: Int
            let resolved: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case reportId = "report_id"
                case resolved, auth
            }
        }
        
        struct ResolveCommentReportResponse {
            // TODO this should probably return the view
            let reportId: Int
            let resolved: Bool
            
            enum CodingKeys: String, CodingKey {
                case reportId = "report_id"
                case resolved
            }
        }
        
        struct ListCommentReports {
            let page: Int?
            let limit: Int?
            /// if no community is given, it returns reports for all communities moderated by the auth user
            let community: Int?
            let auth: String
        }
        
        struct ListCommentReportsResponse {
            let comments: [LMModels.Views.CommentReportView]
        }
        
    }
}
