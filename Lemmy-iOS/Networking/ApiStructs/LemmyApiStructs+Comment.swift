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
        struct GetCommentsRequest: Codable {
            let page: Int
            let limit: Int
            let sort: LemmyFeedType
            let type_: LemmyContentType
            let auth: String?
        }
        
        struct GetComments {
            let comments: Array<CommentView>
        }
    }
}


