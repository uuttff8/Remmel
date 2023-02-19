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
            let languageId: Int?
            let postId: Int
            let formId: String? // An optional front end ID, to tell which is coming back
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case content
                case parentId = "parent_id"
                case languageId = "language_id"
                case postId = "post_id"
                case formId = "form_id"
                case auth
            }
        }
        
        struct EditComment: Codable {
            let content: String?
            let commentId: Int
            let distinguished: Bool?
            let languageId: Int?
            let formId: String?
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case content
                case commentId = "comment_id"
                case distinguished = "distinguished"
                case languageId = "language_id"
                case formId = "form_id"
                case auth
            }
        }
        
        /**
        * Only the creator can delete the comment.
        */
        struct DeleteComment: Codable {
            let commentId: Int
            let deleted: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case commentId = "comment_id"
                case deleted, auth
            }
        }
        
        /**
        * Only a mod or admin can remove the comment.
        */
        struct RemoveComment: Codable {
            let commentId: Int
            let removed: Bool
            let reason: String?
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case commentId = "comment_id"
                case removed, reason, auth
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
            let recipientIds: [Int]
            let formId: String? // An optional front end ID, to tell which is coming back
            
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
        
        /**
        * Comment listing types are `All, Subscribed, Community`
        *
        * `community_name` can only be used for local communities.
        * To get posts for a federated community, pass `community_id` instead.
        */
        struct GetComments: Codable {
            let type: LMModels.Others.ListingType?
            let sort: LMModels.Others.SortType?
            let maxDepth: Int?
            let page: Int?
            let limit: Int?
            let communityId: Int?
            let communityName: String?
            let postId: Int?
            let parentId: Int?
            let savedOnly: Bool?
            let auth: String?
            
            enum CodingKeys: String, CodingKey {
                case type = "type_"
                case sort, page, limit, auth
                case maxDepth = "max_depth"
                case communityId = "community_id"
                case communityName = "community_name"
                case postId = "post_id"
                case parentId = "parent_id"
                case savedOnly = "saved_only"
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
        
        struct CommentReportResponse: Codable {
            let commentReportView: LMModels.Views.CommentReportView

            enum CodingKeys: String, CodingKey {
                case commentReportView = "comment_report_view"
            }
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

        struct ListCommentReports: Codable {
            let page: Int?
            let limit: Int?
            /// if no community is given, it returns reports for all communities moderated by the auth user
            let communityId: Int?
            let unresolvedOnly: Bool?
            let auth: String

            enum CodingKeys: String, CodingKey {
                case page, limit
                case communityId = "community_id"
                case unresolvedOnly = "unresolved_only"
                case auth
            }
        }
        
        struct ListCommentReportsResponse: Codable {
            let comments: [LMModels.Views.CommentReportView]
        }
        
    }
}
