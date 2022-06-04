//
//  LMModels+Ext.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 23.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

extension LMModels.Views.PostView {
    mutating func updateForCreatePostLike(with newPost: LMModels.Views.PostView) {
        counts.score = newPost.counts.score
        counts.upvotes = newPost.counts.upvotes
        counts.downvotes = newPost.counts.downvotes
        if newPost.myVote != nil {
            myVote = newPost.myVote
        }
    }
}

extension LMModels.Views.CommentView {
    mutating func updateForCreatePostLike(with newComment: LMModels.Views.CommentView) {
        counts.score = newComment.counts.score
        counts.upvotes = newComment.counts.upvotes
        counts.downvotes = newComment.counts.downvotes
        if newComment.myVote != nil {
            myVote = newComment.myVote
        }
    }
}

extension LMModels.Source.PersonSafe {
    var originalInstance: String {
        actorId.host ?? ""
    }
}

extension LMModels.Source.CommunitySafe {
    var originalInstance: String {
        actorId.host ?? ""
    }
}
