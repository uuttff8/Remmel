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
    
    func voteReply(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        for newVote: LemmyVoteType,
        reply: LemmyModel.ReplyView,
        completion: @escaping (LemmyModel.CommentView) -> Void
    )
    
    func voteUserMention(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        for newVote: LemmyVoteType,
        userMention: LemmyModel.UserMentionView,
        completion: @escaping (LemmyModel.CommentView) -> Void
    )
}

class ContentScoreService: ContentScoreServiceProtocol {
        
    private let userAccountService: UserAccountSerivceProtocol
    
    private var cancellable = Set<AnyCancellable>()
    
    init(
        userAccountService: UserAccountSerivceProtocol
    ) {
        self.userAccountService = userAccountService
    }
    
    func votePost(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        for newVote: LemmyVoteType,
        post: LemmyModel.PostView,
        completion: @escaping (LemmyModel.PostView) -> Void
    ) {
        
        scoreView.setVoted(voteButton: voteButton, to: newVote)
        self.createPostLike(vote: newVote, postId: post.id)
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
        self.createCommentLike(vote: newVote, contentId: comment.id)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
            } receiveValue: { (comment) in
                completion(comment)
            }.store(in: &cancellable)
    }
    
    func voteReply(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        for newVote: LemmyVoteType,
        reply: LemmyModel.ReplyView,
        completion: @escaping (LemmyModel.CommentView) -> Void
    ) {
        
        scoreView.setVoted(voteButton: voteButton, to: newVote)
        self.createCommentLike(vote: newVote, contentId: reply.id)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
            } receiveValue: { (comment) in
                completion(comment)
            }.store(in: &cancellable)
    }
    
    func voteUserMention(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        for newVote: LemmyVoteType,
        userMention: LemmyModel.UserMentionView,
        completion: @escaping (LemmyModel.CommentView) -> Void
    ) {
        
        scoreView.setVoted(voteButton: voteButton, to: newVote)
        self.createCommentLike(vote: newVote, contentId: userMention.id)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
            } receiveValue: { (comment) in
                completion(comment)
            }.store(in: &cancellable)
    }
    
    
    private func createPostLike(
        vote: LemmyVoteType,
        postId: Int
    ) -> AnyPublisher<LemmyModel.PostView, LemmyGenericError> {
        guard let jwtToken = self.userAccountService.jwtToken
        else {
            return Fail(error: LemmyGenericError.string("failed to fetch jwt token"))
                .eraseToAnyPublisher()
        }
        
        let params = LemmyModel.Post.CreatePostLikeRequest(postId: postId,
                                                           score: vote.rawValue,
                                                           auth: jwtToken)
        
        return ApiManager.requests.asyncCreatePostLike(parameters: params)
            .map({ $0.post })
            .eraseToAnyPublisher()
    }
    
    func createCommentLike(
        vote: LemmyVoteType,
        contentId: Int
    ) -> AnyPublisher<LemmyModel.CommentView, LemmyGenericError> {
        
        guard let jwtToken = self.userAccountService.jwtToken
        else {
            return Fail(error: LemmyGenericError.string("failed to fetch jwt token"))
                .eraseToAnyPublisher()
        }
        
        let params = LemmyModel.Comment.CreateCommentLikeRequest(commentId: contentId,
                                                                 score: vote.rawValue,
                                                                 auth: jwtToken)
        
        return ApiManager.requests.asyncCreateCommentLike(parameters: params)
            .map({ $0.comment })
            .eraseToAnyPublisher()
    }
}
