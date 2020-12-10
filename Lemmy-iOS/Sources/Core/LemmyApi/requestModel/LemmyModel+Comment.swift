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
            let type: LemmyPostListingType
            let sort: LemmySortType
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
            let formId: String?, // An optional form id, so you know which message came bac
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
    }
}
