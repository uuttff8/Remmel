//
//  UpvoteDownvoteViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 04.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Combine
import UIKit
import RMNetworking
import RMModels
import RMFoundation

public protocol ContentScoreServiceProtocol {
    func votePost(
        for newVote: LemmyVoteType,
        post: RMModels.Views.PostView
    )
    
    func voteComment(
        for newVote: LemmyVoteType,
        comment: RMModels.Views.CommentView
    )
    
    func voteReply(
        for newVote: LemmyVoteType,
        reply: RMModels.Views.CommentView
    )
    
    func voteUserMention(
        for newVote: LemmyVoteType,
        userMention: RMModels.Views.PersonMentionView
    )
}

public class ContentScoreService: ContentScoreServiceProtocol {
        
    private let userAccountService: UserAccountServiceProtocol
    private let wsClient: WSClientProtocol
    
    private var cancellable = Set<AnyCancellable>()
    
    public init(
        userAccountService: UserAccountServiceProtocol,
        wsClient: WSClientProtocol = ApiManager.chainedWsCLient
    ) {
        self.userAccountService = userAccountService
        self.wsClient = wsClient
    }
    
    public func votePost(
        for newVote: LemmyVoteType,
        post: RMModels.Views.PostView
    ) {
        guard let jwtToken = self.userAccountService.jwtToken else {
            debugPrint("Cannot get jwt token"); return
        }
        
        let params = RMModels.Api.Post.CreatePostLike(postId: post.id,
                                                      score: newVote.rawValue,
                                                      auth: jwtToken)
        
        self.wsClient.send(RMUserOperation.CreatePostLike, parameters: params)
    }
    
    public func voteComment(
        for newVote: LemmyVoteType,
        comment: RMModels.Views.CommentView
    ) {
        guard let jwtToken = self.userAccountService.jwtToken else {
            debugPrint("Cannot get jwt token"); return
        }
        
        let params = RMModels.Api.Comment.CreateCommentLike(commentId: comment.id,
                                                            score: newVote.rawValue,
                                                            auth: jwtToken)
        wsClient.send(RMUserOperation.CreateCommentLike, parameters: params)
    }
    
    public func voteReply(
        for newVote: LemmyVoteType,
        reply: RMModels.Views.CommentView
    ) {
        self.createCommentLike(contentId: reply.id, vote: newVote)
    }
    
    public func voteUserMention(
        for newVote: LemmyVoteType,
        userMention: RMModels.Views.PersonMentionView
    ) {
        
        self.createCommentLike(contentId: userMention.id, vote: newVote)
    }
    
    func createCommentLike(
        contentId: Int,
        vote: LemmyVoteType
    ) {
        guard let jwtToken = self.userAccountService.jwtToken else {
            debugPrint("Cannot get jwt token"); return
        }
        let params = RMModels.Api.Comment.CreateCommentLike(commentId: contentId,
                                                            score: vote.rawValue,
                                                            auth: jwtToken)
        wsClient.send(RMUserOperation.CreateCommentLike, parameters: params)
    }
}
