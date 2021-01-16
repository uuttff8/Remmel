//
//  LemmyApiStructs+Comment.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

extension LemmyModel {
    enum Comment {

        // MARK: - GetComments -
        struct GetCommentsRequest: Codable, Equatable {
            let type: LMModels.Others.ListingType
            let sort: LMModels.Others.SortType
            let page: Int
            let limit: Int
            let auth: String?

            enum CodingKeys: String, CodingKey {
                case type = "type_"
                case sort, page, limit, auth
            }
        }

        struct GetCommentsResponse: Codable, Equatable {
            let comments: [CommentView]
        }
        
        // MARK: - CreateComment -
        struct CreateCommentRequest: Codable, Equatable, Hashable {
            let content: String
            let parentId: Int?
            let postId: Int
            let formId: String? // An optional form id, so you know which message came bac
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case content
                case parentId = "parent_id"
                case postId = "post_id"
                case formId = "form_id"
                case auth
            }
        }
        
        struct CreateCommentResponse: Codable, Equatable, Hashable {
            let comment: CommentView
        }
        
        // MARK: - EditComment -
        struct EditCommentRequest: Codable, Equatable, Hashable {
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
        
        struct EditCommentResponse: Codable, Equatable, Hashable {
            let comment: CommentView
        }
        
        // MARK: - DeleteComment -
        struct DeleteCommentRequest: Codable, Equatable, Hashable {
            let editId: Int
            let deleted: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case editId = "edit_id"
                case deleted
                case auth
            }
        }
        
        struct DeleteCommentResponse: Codable, Equatable, Hashable {
            let comment: CommentView
        }
        
        // MARK: - RemoveComment -
        struct RemoveCommentRequest: Codable, Equatable, Hashable {
            let editId: Int
            let removed: Bool
            let reason: String?
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case editId = "edit_id"
                case removed, reason, auth
            }
        }
        
        struct RemoveCommentResponse: Codable, Equatable, Hashable {
            let comment: CommentView
        }
        
        // MARK: - MarkCommentAsRead -
        struct MarkCommentAsReadRequest: Codable, Equatable, Hashable {
            let editId: Int
            let read: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case editId = "edit_id"
                case read, auth
            }
        }
        
        struct MarkCommentAsReadResponse: Codable, Equatable, Hashable {
            let comment: CommentView
        }
        
        // MARK: - SaveComment -
        struct SaveCommentRequest: Codable, Equatable, Hashable {
            let commentId: Int
            let save: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case commentId = "comment_id"
                case save, auth
            }
        }
        
        struct SaveCommentResponse: Codable, Equatable, Hashable {
            let comment: CommentView
        }
        
        // MARK: - CreateCommentLike -
        struct CreateCommentLikeRequest: Codable, Equatable, Hashable {
            let commentId: Int
            let score: Int
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case commentId = "comment_id"
                case score, auth
            }
        }
        
        struct CreateCommentLikeResponse: Codable, Equatable, Hashable {
            let comment: CommentView
        }
        
        // MARK: - CreateCommentReport -
        struct CreateCommentReportRequest: Codable, Equatable, Hashable {
            let commentId: Int
            let reason: String
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case commentId = "comment_id"
                case reason, auth
            }
        }
        
        struct CreateCommentReportResponse: Codable, Equatable, Hashable {
            let success: Bool
        }
        
        // MARK: - ResolveCommentReport -
        struct ResolveCommentReportRequest: Codable, Equatable, Hashable {
            let reportId: Int
            let resolved: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case reportId = "report_id"
                case resolved, auth
            }
        }
        
        struct ResolveCommentReportResponse: Codable, Equatable, Hashable {
            let reportId: Int
            let resolved: Bool
            
            enum CodingKeys: String, CodingKey {
                case reportId = "report_id"
                case resolved
            }
        }
        
        struct ListCommentReportsRequest: Codable, Equatable, Hashable {
            let page: Int?
            let limit: Int?
            let community: Int?
            let auth: String
        }
        
        struct ListCommentReportsResponse: Codable, Equatable, Hashable {
            let comments: [CommentReportView]
        }
    }
}
