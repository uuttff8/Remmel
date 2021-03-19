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
        post: LMModels.Views.PostView
    )
    
    func voteComment(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        for newVote: LemmyVoteType,
        comment: LMModels.Views.CommentView
    )
    
    func voteReply(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        for newVote: LemmyVoteType,
        reply: LMModels.Views.CommentView
    )
    
    func voteUserMention(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        for newVote: LemmyVoteType,
        userMention: LMModels.Views.PersonMentionView
    )
}

class ContentScoreService: ContentScoreServiceProtocol {
        
    private let userAccountService: UserAccountSerivceProtocol
    private let wsClient: WSClientProtocol
    
    private var cancellable = Set<AnyCancellable>()
    
    init(
        userAccountService: UserAccountSerivceProtocol,
        wsClient: WSClientProtocol = ApiManager.chainedWsCLient
    ) {        
        self.userAccountService = userAccountService
        self.wsClient = wsClient
    }
    
    func votePost(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        for newVote: LemmyVoteType,
        post: LMModels.Views.PostView
    ) {
        guard let jwtToken = self.userAccountService.jwtToken else {
            Logger.commonLog.emergency("Cannot get jwt token"); return
        }
        
        scoreView.setVoted(voteButton: voteButton, to: newVote)
        let params = LMModels.Api.Post.CreatePostLike(postId: post.id,
                                                      score: newVote.rawValue,
                                                      auth: jwtToken)
        
        self.wsClient.send(LMMUserOperation.CreatePostLike, parameters: params)
    }
    
    func voteComment(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        for newVote: LemmyVoteType,
        comment: LMModels.Views.CommentView
    ) {
        guard let jwtToken = self.userAccountService.jwtToken else {
            Logger.commonLog.emergency("Cannot get jwt token"); return
        }
        
        scoreView.setVoted(voteButton: voteButton, to: newVote)
        
        let params = LMModels.Api.Comment.CreateCommentLike(commentId: comment.id,
                                                            score: newVote.rawValue,
                                                            auth: jwtToken)
        wsClient.send(LMMUserOperation.CreateCommentLike, parameters: params)
    }
    
    func voteReply(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        for newVote: LemmyVoteType,
        reply: LMModels.Views.CommentView
    ) {
        self.createCommentLike(contentId: reply.id, vote: newVote, scoreView: scoreView, voteButton: voteButton)
    }
    
    func voteUserMention(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        for newVote: LemmyVoteType,
        userMention: LMModels.Views.PersonMentionView
    ) {
        
        self.createCommentLike(contentId: userMention.id, vote: newVote, scoreView: scoreView, voteButton: voteButton)
    }
    
    func createCommentLike(
        contentId: Int,
        vote: LemmyVoteType,
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton
    ) {
        guard let jwtToken = self.userAccountService.jwtToken else {
            Logger.commonLog.emergency("Cannot get jwt token"); return
        }
        
        scoreView.setVoted(voteButton: voteButton, to: vote)
        
        let params = LMModels.Api.Comment.CreateCommentLike(commentId: contentId,
                                                            score: vote.rawValue,
                                                            auth: jwtToken)
        wsClient.send(LMMUserOperation.CreateCommentLike, parameters: params)
    }
}
