//
//  CommentListingSort.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/28/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

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
    
    func createTreeOfReplies(in comments: Array<LemmyApiStructs.CommentView>) -> Array<LemmyApiStructs.CommentView> {
        // TODO: Create tree of replies
        return []
    }
}
