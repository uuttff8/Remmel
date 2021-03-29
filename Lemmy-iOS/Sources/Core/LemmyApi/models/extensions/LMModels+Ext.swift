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
        self.counts.score = newPost.counts.score
        self.counts.upvotes = newPost.counts.upvotes
        self.counts.downvotes = newPost.counts.downvotes
        if newPost.myVote != nil {
            self.myVote = newPost.myVote
        }
    }
}

extension LMModels.Views.CommentView {
    mutating func updateForCreatePostLike(with newComment: LMModels.Views.CommentView) {
        self.counts.score = newComment.counts.score
        self.counts.upvotes = newComment.counts.upvotes
        self.counts.downvotes = newComment.counts.downvotes
        if newComment.myVote != nil {
            self.myVote = newComment.myVote
        }
    }
}

extension LMModels.Source.PersonSafe {
    var originalInstance: String {
        extractInstance(instance: self.actorId)
    }
}

extension LMModels.Source.CommunitySafe {
    var originalInstance: String {
        extractInstance(instance: self.actorId)
    }
}

extension LMModels.Source.LocalUserSettings {
//    var originalInstance: String {
//        extractInstance(instance: self.actorId)
//    }
}

private func extractInstance(instance url: URL) -> String {
    return url.host!
}
