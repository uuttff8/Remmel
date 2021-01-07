//
//  ReplyMentionProtocols.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 07.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol ReplyCellViewDelegate: AnyObject {
    func usernameTapped(in comment: LemmyModel.ReplyView)
    func communityTapped(in comment: LemmyModel.ReplyView)
    func postNameTapped(in comment: LemmyModel.ReplyView)
    func voteContent(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        newVote: LemmyVoteType,
        comment: LemmyModel.ReplyView
    )
    func showContext(in comment: LemmyModel.ReplyView)
    func reply(to comment: LemmyModel.ReplyView)
    func onLinkTap(in comment: LemmyModel.ReplyView, url: URL)
    func onMentionTap(in post: LemmyModel.ReplyView, mention: LemmyMention)
    func showMoreAction(in comment: LemmyModel.ReplyView)
}

protocol UserMentionCellViewDelegate: AnyObject {
    func usernameTapped(in comment: LemmyModel.UserMentionView)
    func communityTapped(in comment: LemmyModel.UserMentionView)
    func postNameTapped(in comment: LemmyModel.UserMentionView)
    func voteContent(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        newVote: LemmyVoteType,
        comment: LemmyModel.UserMentionView
    )
    func showContext(in comment: LemmyModel.UserMentionView)
    func reply(to comment: LemmyModel.UserMentionView)
    func onLinkTap(in comment: LemmyModel.UserMentionView, url: URL)
    func onMentionTap(in post: LemmyModel.UserMentionView, mention: LemmyMention)
    func showMoreAction(in comment: LemmyModel.UserMentionView)
}

