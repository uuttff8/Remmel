//
//  ReplyMentionProtocols.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 07.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol ReplyCellViewDelegate: AnyObject {
    func usernameTapped(with userMention: LemmyUserMention)
    func communityTapped(with userMention: LemmyCommunityMention)
    func postNameTapped(in reply: LMModels.Views.CommentView)
    func voteContent(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        newVote: LemmyVoteType,
        reply: LMModels.Views.CommentView
    )
    func showContext(in reply: LMModels.Views.CommentView)
    func reply(to reply: LMModels.Views.CommentView)
    func onLinkTap(in userMention: LMModels.Views.CommentView, url: URL)
    func showMoreAction(in reply: LMModels.Views.CommentView)
}

protocol UserMentionCellViewDelegate: AnyObject {
    func usernameTapped(with userMention: LemmyUserMention)
    func communityTapped(with userMention: LemmyCommunityMention)
    func postNameTapped(in userMention: LMModels.Views.UserMentionView)
    func voteContent(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        newVote: LemmyVoteType,
        userMention: LMModels.Views.UserMentionView
    )
    func showContext(in userMention: LMModels.Views.UserMentionView)
    func reply(to userMention: LMModels.Views.UserMentionView)
    func onLinkTap(in userMention: LMModels.Views.UserMentionView, url: URL)
    func showMoreAction(in userMention: LMModels.Views.UserMentionView)
}
