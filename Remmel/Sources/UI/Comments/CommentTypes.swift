//
//  CommentTypes.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 25.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation
import RMModels

class LemmyComment: BaseComment, Identifiable {
    var id: Int? {
        commentContent?.comment.id
    }
    var commentContent: RMModels.Views.CommentView?
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
