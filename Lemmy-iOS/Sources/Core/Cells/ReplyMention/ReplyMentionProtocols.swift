//
//  ReplyMentionProtocols.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 07.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol ReplyCellViewDelegate: AnyObject {
    func usernameTapped(in reply: LemmyModel.ReplyView)
    func communityTapped(in reply: LemmyModel.ReplyView)
    func postNameTapped(in reply: LemmyModel.ReplyView)
    func voteContent(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        newVote: LemmyVoteType,
        reply: LemmyModel.ReplyView
    )
    func showContext(in reply: LemmyModel.ReplyView)
    func reply(to reply: LemmyModel.ReplyView)
    func onLinkTap(in reply: LemmyModel.ReplyView, url: URL)
    func onMentionTap(in reply: LemmyModel.ReplyView, mention: LemmyMention)
    func showMoreAction(in reply: LemmyModel.ReplyView)
}

protocol UserMentionCellViewDelegate: AnyObject {
    func usernameTapped(in userMention: LemmyModel.UserMentionView)
    func communityTapped(in userMention: LemmyModel.UserMentionView)
    func postNameTapped(in userMention: LemmyModel.UserMentionView)
    func voteContent(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        newVote: LemmyVoteType,
        userMention: LemmyModel.UserMentionView
    )
    func showContext(in userMention: LemmyModel.UserMentionView)
    func reply(to userMention: LemmyModel.UserMentionView)
    func onLinkTap(in userMention: LemmyModel.UserMentionView, url: URL)
    func onMentionTap(in userMention: LemmyModel.UserMentionView, mention: LemmyMention)
    func showMoreAction(in userMention: LemmyModel.UserMentionView)
}
