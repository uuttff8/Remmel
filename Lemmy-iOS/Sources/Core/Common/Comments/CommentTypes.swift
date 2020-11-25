//
//  CommentTypes.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 25.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

class LemmyComment: BaseComment {
    var id: Int? {
        commentContent?.id
    }
    var commentContent: LemmyModel.CommentView?
    var isFolded: Bool = true
}

class BaseComment: AbstractComment {
    var replies: [AbstractComment]! = []
    var level: Int!
    weak var replyTo: AbstractComment?
    
    convenience init() {
        self.init(level: 0, replyTo: nil)
    }
    
    init(level: Int, replyTo: BaseComment?) {
        self.level = level
        self.replyTo = replyTo
    }
    
    func addReply(_ reply: BaseComment) {
        self.replies.append(reply)
    }
}

struct CommentNode {
    let id: Int
    let comment: LemmyModel.CommentView
    var replies: [CommentNode]
}
