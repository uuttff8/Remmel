//
//  LemmyApiStructs+Comment.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

extension LemmyApiStructs {
    enum Comment {
        
        // MARK: - GetComments -
        struct GetCommentsRequest: Codable, Equatable {
            let type_: LemmyFeedType
            let sort: LemmySortType
            let page: Int
            let limit: Int
            let auth: String?
        }
        
        struct GetCommentsResponse: Codable, Equatable {
            let comments: Array<CommentView>
        }
    }
}


