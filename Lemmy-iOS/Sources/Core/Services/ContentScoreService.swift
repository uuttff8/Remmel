//
//  UpvoteDownvoteViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 04.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Combine
import UIKit

protocol ContentScoreServiceProtocol {
    func votePost(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        for newVote: LemmyVoteType,
        post: LemmyModel.PostView,
        completion: @escaping (LemmyModel.PostView) -> Void
    )
    
    func voteComment(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        for newVote: LemmyVoteType,
        comment: LemmyModel.CommentView,
        completion: @escaping (LemmyModel.CommentView) -> Void
    )
}

class ContentScoreService: ContentScoreServiceProtocol {
    
    private let voteService: UpvoteDownvoteRequestServiceProtocol
    
    private var cancellable = Set<AnyCancellable>()
    
    init(
        voteService: UpvoteDownvoteRequestServiceProtocol
    ) {
        self.voteService = voteService
    }
    
    func votePost(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        for newVote: LemmyVoteType,
        post: LemmyModel.PostView,
        completion: @escaping (LemmyModel.PostView) -> Void
    ) {
        
        scoreView.setVoted(voteButton: voteButton, to: newVote)
        self.voteService.createPostLike(vote: newVote, post: post)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
            } receiveValue: { (post) in
                completion(post)
            }.store(in: &cancellable)
        
    }
    
    func voteComment(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        for newVote: LemmyVoteType,
        comment: LemmyModel.CommentView,
        completion: @escaping (LemmyModel.CommentView) -> Void
    ) {
        
        scoreView.setVoted(voteButton: voteButton, to: newVote)
        self.voteService.createCommentLike(vote: newVote, comment: comment)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
            } receiveValue: { (comment) in
                completion(comment)
            }.store(in: &cancellable)
    }
}
