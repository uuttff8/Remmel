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
        post: LMModels.Views.PostView,
        completion: @escaping (LMModels.Views.PostView) -> Void
    )
    
    func voteComment(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        for newVote: LemmyVoteType,
        comment: LMModels.Views.CommentView,
        completion: @escaping (LMModels.Views.CommentView) -> Void
    )
    
    func voteReply(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        for newVote: LemmyVoteType,
        reply: LMModels.Views.CommentView,
        completion: @escaping (LMModels.Views.CommentView) -> Void
    )
    
    func voteUserMention(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        for newVote: LemmyVoteType,
        userMention: LMModels.Views.UserMentionView,
        completion: @escaping (LMModels.Views.CommentView) -> Void
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
        post: LMModels.Views.PostView,
        completion: @escaping (LMModels.Views.PostView) -> Void
    ) {
        
        scoreView.setVoted(voteButton: voteButton, to: newVote)
        self.createPostLike(vote: newVote, postId: post.post.id)
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
        comment: LMModels.Views.CommentView,
        completion: @escaping (LMModels.Views.CommentView) -> Void
    ) {
        
        scoreView.setVoted(voteButton: voteButton, to: newVote)
        self.createCommentLike(vote: newVote, contentId: comment.comment.id)
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
        reply: LMModels.Views.CommentView,
        completion: @escaping (LMModels.Views.CommentView) -> Void
    ) {
        
        scoreView.setVoted(voteButton: voteButton, to: newVote)
        self.createCommentLike(vote: newVote, contentId: reply.comment.id)
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
        userMention: LMModels.Views.UserMentionView,
        completion: @escaping (LMModels.Views.CommentView) -> Void
    ) {
        
        scoreView.setVoted(voteButton: voteButton, to: newVote)
        self.createCommentLike(vote: newVote, contentId: userMention.creator.id)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
            } receiveValue: { (comment) in
                completion(comment)
            }.store(in: &cancellable)
    }
    
    func createPostLike(
        vote: LemmyVoteType,
        postId: Int
    ) -> AnyPublisher<LMModels.Views.PostView, LemmyGenericError> {
        guard let jwtToken = self.userAccountService.jwtToken
        else {
            return Fail(error: LemmyGenericError.string("failed to fetch jwt token"))
                .eraseToAnyPublisher()
        }
        
        let params = LMModels.Api.Post.CreatePostLike(postId: postId,
                                                           score: vote.rawValue,
                                                           auth: jwtToken)
        
        return ApiManager.requests.asyncCreatePostLike(parameters: params)
            .map({ $0.postView })
            .eraseToAnyPublisher()
    }
    
    func createCommentLike(
        vote: LemmyVoteType,
        contentId: Int
    ) -> AnyPublisher<LMModels.Views.CommentView, LemmyGenericError> {
        
        guard let jwtToken = self.userAccountService.jwtToken
        else {
            return Fail(error: LemmyGenericError.string("failed to fetch jwt token"))
                .eraseToAnyPublisher()
        }
        
        let params = LMModels.Api.Comment.CreateCommentLike(commentId: contentId,
                                                            score: vote.rawValue,
                                                            auth: jwtToken)
        
        return ApiManager.requests.asyncCreateCommentLike(parameters: params)
            .map({ $0.commentView })
            .eraseToAnyPublisher()
    }
}
