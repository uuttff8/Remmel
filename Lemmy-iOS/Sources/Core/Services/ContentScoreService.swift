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
        voteButton: VoteButton,
        for newVote: LemmyVoteType,
        post: LemmyModel.PostView,
        completion: @escaping (LemmyModel.PostView) -> Void
    )
    
    func voteComment(
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
        voteButton: VoteButton,
        for newVote: LemmyVoteType,
        post: LemmyModel.PostView,
        completion: @escaping (LemmyModel.PostView) -> Void
    ) {
        
        voteButton.setVoted(to: newVote)
        self.voteService.createPostLike(vote: newVote, post: post)
            .receive(on: RunLoop.main)
            .sink { (completion) in
                print(completion)
            } receiveValue: { (post) in
                completion(post)
            }.store(in: &cancellable)
        
    }
    
    func voteComment(
        voteButton: VoteButton,
        for newVote: LemmyVoteType,
        comment: LemmyModel.CommentView,
        completion: @escaping (LemmyModel.CommentView) -> Void
    ) {
        
        voteButton.setVoted(to: newVote)
        self.voteService.createCommentLike(vote: newVote, comment: comment)
            .receive(on: RunLoop.main)
            .sink { (completion) in
                print(completion)
            } receiveValue: { (post) in
                completion(post)
            }.store(in: &cancellable)
    }
}
