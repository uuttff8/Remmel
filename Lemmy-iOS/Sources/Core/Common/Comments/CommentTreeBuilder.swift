//
//  CommentListingSort.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/28/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

// MARK: - CommentTreeBuilder -
class CommentTreeBuilder {
    
    // MARK: - Properties
    
    private let comments: [LMModels.Views.CommentView]
    
    // MARK: - Init
    
    init(comments: [LMModels.Views.CommentView]) {
        self.comments = comments
    }
    
    // MARK: - Public API    

    func createCommentsTree() -> [LemmyComment] {
        let notReplies = findNotReplyComments(in: comments)
        var nodes = [LemmyComment]()
        
        for notReply in notReplies {
            let parentComment = LemmyComment(level: 0, replyTo: nil)
            parentComment.commentContent = notReply
            
            nodes.append(createReplyTree(for: parentComment))
        }
        
        return nodes
    }
    
    // MARK: - Private API
    
    private func sortComments() -> [LMModels.Views.CommentView] {
        let sortedArray = comments.sorted(by: { (comm1, comm2) in
            let date1 = comm1.comment.published
            let date2 = comm2.comment.published
            
            return date1.compare(date2) == .orderedAscending
        })
        
        return sortedArray
    }
    
    private func findNotReplyComments(in comments: [LMModels.Views.CommentView]) -> [LMModels.Views.CommentView] {
        var notReply = [LMModels.Views.CommentView]()
        
        for comm in comments where comm.comment.parentId == nil {
            notReply.append(comm)
        }
        
        return notReply
    }
    
    private func findCommentsExcludeNotReply(
        in comments: [LMModels.Views.CommentView]
    ) -> [LMModels.Views.CommentView] {
        var repliesOnly = [LMModels.Views.CommentView]()
        
        for comm in comments where comm.comment.parentId != nil {
            repliesOnly.append(comm)
        }
        
        return repliesOnly
    }
    
    private func createReplyTree(for parent: LemmyComment) -> LemmyComment {
        var replies = [LemmyComment]()
                
        for repliedComm in self.comments
        where repliedComm.comment.parentId == parent.id {
            
            let child = LemmyComment(level: 0, replyTo: nil)
            
            child.replyTo = parent
            child.commentContent = repliedComm
            child.level = parent.level + 1

            parent.addReply(child)
            
            replies.append(createReplyTree(for: child))
        }
        
        parent.replies = replies
        
        return parent
    }
}
