//
//  LMModels+Ext.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 23.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

extension RMModels.Views.PostView {
    mutating func updateForCreatePostLike(with newPost: RMModels.Views.PostView) {
        counts.score = newPost.counts.score
        counts.upvotes = newPost.counts.upvotes
        counts.downvotes = newPost.counts.downvotes
        if newPost.myVote != nil {
            myVote = newPost.myVote
        }
    }
}

extension RMModels.Views.CommentView {
    mutating func updateForCreatePostLike(with newComment: RMModels.Views.CommentView) {
        counts.score = newComment.counts.score
        counts.upvotes = newComment.counts.upvotes
        counts.downvotes = newComment.counts.downvotes
        if newComment.myVote != nil {
            myVote = newComment.myVote
        }
    }
}

extension RMModels.Source.PersonSafe {
    var originalInstance: String {
        actorId.host ?? ""
    }
}

extension RMModels.Source.CommunitySafe {
    var originalInstance: String {
        actorId.host ?? ""
    }
}
