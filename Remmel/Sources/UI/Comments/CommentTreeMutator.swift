//
//  CommentTreeMutator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 19.02.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation
import RMModels

// MARK: - CommentTreeMutator -
class CommentTreeMutator {
    
    // MARK: - Properties
    
    var buildedComments: [LemmyComment]
    
    // MARK: - Init
    
    init(buildedComments: inout [LemmyComment]) {
        self.buildedComments = buildedComments
    }
    
    // MARK: - API
    
    func insert(comment: RMModel.Views.CommentView) {
        let newComment = LemmyComment(level: 0, replyTo: nil)
        newComment.commentContent = comment
        
        if let parentId = comment.comment.parentId {
            
            // shift newComment to a parentComment
            if let parentComment = buildedComments.getElement(by: parentId) {
                let newLevel = parentComment.level + 1
                
                newComment.level = newLevel
                newComment.replyTo = parentComment
                
                parentComment.replies.append(newComment)
            } else {
                // do nothing, because:
                // creatorComment not appear in prebuild for some reason like internet issues
                // so dont show reply, user will this comment if he/she reloads it
                debugPrint("New comment created with creatorId, but that parent comment is not found")
                return // no insert happen
            }
            
        } else {
            // if parentComment is not found, just show it as a new comment
            buildedComments.insert(newComment, at: 0)
        }
    }
}
