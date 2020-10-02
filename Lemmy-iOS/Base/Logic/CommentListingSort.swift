//
//  CommentListingSort.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/28/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

struct CommentNode {
    let comment: LemmyApiStructs.CommentView
    var replies: [CommentNode]
}

class CommentListingSort {
    let comments: Array<LemmyApiStructs.CommentView>
    
    init(comments: Array<LemmyApiStructs.CommentView>) {
        self.comments = comments
    }
    
    func sortComments() -> Array<LemmyApiStructs.CommentView> {
        let sortedArray = comments.sorted(by: { (comm1, comm2) in
            let date1 = Date.toLemmyDate(str: comm1.published)
            let date2 = Date.toLemmyDate(str: comm2.published)
            
            return date1.compare(date2) == .orderedAscending
        })
        
        return sortedArray
    }
    
    func findNotReplyComments(in comments: Array<LemmyApiStructs.CommentView>) -> Array<LemmyApiStructs.CommentView> {
        var notReply = [LemmyApiStructs.CommentView]()
        
        for comm in comments {
            if comm.parentId == nil {
                notReply.append(comm)
            }
        }
        
        return notReply
    }
    
    func findCommentsExcludeNotReply(in comments: Array<LemmyApiStructs.CommentView>) -> Array<LemmyApiStructs.CommentView> {
        var repliesOnly = [LemmyApiStructs.CommentView]()
        
        for comm in comments {
            if let _ = comm.parentId {
                repliesOnly.append(comm)
            }
        }
        
        return repliesOnly
    }
    
    func createTreeOfReplies() -> Array<CommentNode> {
        // TODO: Create tree of replies
        
        let notReplies = findNotReplyComments(in: comments)
        var nodes = [CommentNode]()
        
        for notReply in notReplies {
            nodes.append(createReplyTree(for: notReply))
        }
        
        
        return nodes
    }
    
    func createReplyTree(for comment: LemmyApiStructs.CommentView) -> CommentNode {
        var replies = [CommentNode]()
        var node = CommentNode(comment: comment, replies: replies)
        
        for repliedComm in self.comments {
            
            if repliedComm.parentId == comment.id {
                replies.append(createReplyTree(for: repliedComm))
            }
            
        }
        
        node.replies = replies
        
        return node
    }
}
