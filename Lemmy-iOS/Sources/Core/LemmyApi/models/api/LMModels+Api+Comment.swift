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
        
        struct DeleteComment: Codable {
            let editId: Int
            let deleted: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case editId = "edit_id"
                case deleted, auth
            }
        }
        
        struct RemoveComment: Codable {
            let editId: Int
            let removed: Bool
            let reason: String?
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case editId = "edit_id"
                case removed, reason, auth
            }
        }
        
        struct MarkCommentAsRead: Codable {
            let commentId: Int
            let read: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case commentId = "comment_id"
                case read, auth
            }
        }
        
        struct SaveComment: Codable {
            let commentId: Int
            let save: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case commentId = "comment_id"
                case save, auth
            }
        }
        
        struct CommentResponse: Codable {
            let commentView: LMModels.Views.CommentView
            let recipientIds: [Int]  // TODO another way to do this? Maybe a UserMention belongs to Comment
            let formId: Int  // An optional front end ID, to tell which is coming ba,
            
            enum CodingKeys: String, CodingKey {
                case commentView = "comment_view"
                case recipientIds = "recipient_ids"
                case formId = "form_id"
            }
        }
        
        struct CreateCommentLike: Codable {
            let commentId: Int
            let score: Int
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case commentId = "comment_id"
                case score
                case auth
            }
        }
        
        struct GetComments: Codable {
            let type: LMModels.Others.ListingType
            let sort: LMModels.Others.SortType
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
        
        struct GetCommentsResponse: Codable {
            let comments: [LMModels.Views.CommentView]
        }
        
        struct CreateCommentReport: Codable {
            let commentId: Int
            let reason: String
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case commentId = "comment_id"
                case reason, auth
            }
        }
        
        struct CreateCommentReportResponse: Codable {
            let success: Bool
        }
        
        struct ResolveCommentReport: Codable {
            let reportId: Int
            let resolved: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case reportId = "report_id"
                case resolved, auth
            }
        }
        
        struct ResolveCommentReportResponse: Codable {
            // TODO this should probably return the view
            let reportId: Int
            let resolved: Bool
            
            enum CodingKeys: String, CodingKey {
                case reportId = "report_id"
                case resolved
            }
        }
        
        struct ListCommentReports: Codable {
            let page: Int?
            let limit: Int?
            /// if no community is given, it returns reports for all communities moderated by the auth user
            let community: Int?
            let auth: String
        }
        
        struct ListCommentReportsResponse: Codable {
            let comments: [LMModels.Views.CommentReportView]
        }
        
    }
}
