//
//  CommentListingSort.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/28/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

// MARK: - CommentListingSort -
class CommentListingSort {
    
    // MARK: - Properties
    
    private let comments: [LemmyModel.CommentView]
    
    // MARK: - Init
    
    init(comments: [LemmyModel.CommentView]) {
        self.comments = comments
    }
    
    // MARK: - Public API    

    func createCommentsTree() -> [LemmyComment] {
        let notReplies = findNotReplyComments(in: comments)
        var nodes = [LemmyComment]()
        
        for notReply in notReplies {
            let parentComment = LemmyComment()
            parentComment.commentContent = notReply
            
            nodes.append(createReplyTree(for: parentComment))
        }
        
        return nodes
    }
    
    // MARK: - Private API
    
    private func sortComments() -> [LemmyModel.CommentView] {
        let sortedArray = comments.sorted(by: { (comm1, comm2) in
            let date1 = comm1.published
            let date2 = comm2.published
            
            return date1.compare(date2) == .orderedAscending
        })
        
        return sortedArray
    }
    
    private func findNotReplyComments(in comments: [LemmyModel.CommentView]) -> [LemmyModel.CommentView] {
        var notReply = [LemmyModel.CommentView]()
        
        for comm in comments where comm.parentId == nil {
            notReply.append(comm)
        }
        
        return notReply
    }
    
    private func findCommentsExcludeNotReply(in comments: [LemmyModel.CommentView]) -> [LemmyModel.CommentView] {
        var repliesOnly = [LemmyModel.CommentView]()
        
        for comm in comments where comm.parentId != nil {
            repliesOnly.append(comm)
        }
        
        return repliesOnly
    }
    
    private func createReplyTree(for parent: LemmyComment) -> LemmyComment {
        var replies = [LemmyComment]()
                
        for repliedComm in self.comments
        where repliedComm.parentId == parent.id {
            
            let child = LemmyComment()
            
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
