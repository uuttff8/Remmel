//
//  RMModels+Api+Comment.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 15.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

public extension RMModels.Api {
    enum Comment {
        
        public struct CreateComment: Codable {
            public let content: String
            public let parentId: Int?
            public let languageId: Int?
            public let postId: Int
            public let formId: String? // An optional front end ID, to tell which is coming back
            public let auth: String
            
            public init(content: String, parentId: Int?, languageId: Int?, postId: Int, formId: String?, auth: String) {
                self.content = content
                self.parentId = parentId
                self.languageId = languageId
                self.postId = postId
                self.formId = formId
                self.auth = auth
            }
            
            enum CodingKeys: String, CodingKey {
                case content
                case parentId = "parent_id"
                case languageId = "language_id"
                case postId = "post_id"
                case formId = "form_id"
                case auth
            }
        }
        
        public struct EditComment: Codable {
            public let content: String?
            public let commentId: Int
            public let distinguished: Bool?
            public let languageId: Int?
            public let formId: String?
            public let auth: String
            
            public init(content: String?, commentId: Int, distinguished: Bool?, languageId: Int?, formId: String?, auth: String) {
                self.content = content
                self.commentId = commentId
                self.distinguished = distinguished
                self.languageId = languageId
                self.formId = formId
                self.auth = auth
            }
            
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
        public struct DeleteComment: Codable {
            public let commentId: Int
            public let deleted: Bool
            public let auth: String
            
            enum CodingKeys: String, CodingKey {
                case commentId = "comment_id"
                case deleted, auth
            }
        }
        
        /**
        * Only a mod or admin can remove the comment.
        */
        public struct RemoveComment: Codable {
            public let commentId: Int
            public let removed: Bool
            public let reason: String?
            public let auth: String
            
            enum CodingKeys: String, CodingKey {
                case commentId = "comment_id"
                case removed, reason, auth
            }
        }
                
        public struct SaveComment: Codable {
            public let commentId: Int
            public let save: Bool
            public let auth: String
            
            enum CodingKeys: String, CodingKey {
                case commentId = "comment_id"
                case save, auth
            }
        }
        
        public struct CommentResponse: Codable {
            public let commentView: RMModels.Views.CommentView
            public let recipientIds: [Int]
            public let formId: String? // An optional front end ID, to tell which is coming back
            
            enum CodingKeys: String, CodingKey {
                case commentView = "comment_view"
                case recipientIds = "recipient_ids"
                case formId = "form_id"
            }
        }
        
        public struct CreateCommentLike: Codable {
            public let commentId: Int
            public let score: Int
            public let auth: String
            
            public init(commentId: Int, score: Int, auth: String) {
                self.commentId = commentId
                self.score = score
                self.auth = auth
            }
            
            enum CodingKeys: String, CodingKey {
                case commentId = "comment_id"
                case score
                case auth
            }
        }
        
        /**
        * Comment listing types are `All, Subscribed, Community`
        * `community_name` can only be used for local communities.
        * To get posts for a federated community, pass `community_id` instead.
        */
        public struct GetComments: Codable {
            public let type: RMModels.Others.ListingType?
            public let sort: RMModels.Others.CommentSortType?
            public let maxDepth: Int?
            public let page: Int?
            public let limit: Int?
            public let communityId: Int?
            public let communityName: String?
            public let postId: Int?
            public let parentId: Int?
            public let savedOnly: Bool?
            public let auth: String?
            
            public init(type: RMModels.Others.ListingType?, sort: RMModels.Others.CommentSortType?, maxDepth: Int?, page: Int?, limit: Int?, communityId: Int?, communityName: String?, postId: Int?, parentId: Int?, savedOnly: Bool?, auth: String?) {
                self.type = type
                self.sort = sort
                self.maxDepth = maxDepth
                self.page = page
                self.limit = limit
                self.communityId = communityId
                self.communityName = communityName
                self.postId = postId
                self.parentId = parentId
                self.savedOnly = savedOnly
                self.auth = auth
            }
            
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
        
        public struct GetCommentsResponse: Codable {
            public let comments: [RMModels.Views.CommentView]
        }
        
        public struct CreateCommentReport: Codable {
            public let commentId: Int
            public let reason: String
            public let auth: String
            
            enum CodingKeys: String, CodingKey {
                case commentId = "comment_id"
                case reason, auth
            }
        }
        
        public struct CommentReportResponse: Codable {
            public let commentReportView: RMModels.Views.CommentReportView

            enum CodingKeys: String, CodingKey {
                case commentReportView = "comment_report_view"
            }
        }
        
        public struct ResolveCommentReport: Codable {
            public let reportId: Int
            public let resolved: Bool
            public let auth: String
            
            enum CodingKeys: String, CodingKey {
                case reportId = "report_id"
                case resolved, auth
            }
        }

        public struct ListCommentReports: Codable {
            public let page: Int?
            public let limit: Int?
            /// if no community is given, it returns reports for all communities moderated by the auth user
            public let communityId: Int?
            public let unresolvedOnly: Bool?
            public let auth: String

            enum CodingKeys: String, CodingKey {
                case page, limit
                case communityId = "community_id"
                case unresolvedOnly = "unresolved_only"
                case auth
            }
        }
        
        public struct ListCommentReportsResponse: Codable {
            public let comments: [RMModels.Views.CommentReportView]
        }
    }
}
