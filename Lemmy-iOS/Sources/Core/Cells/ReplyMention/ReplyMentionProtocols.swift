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
    func postNameTapped(in reply: LemmyModel.ReplyView)
    func voteContent(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        newVote: LemmyVoteType,
        reply: LemmyModel.ReplyView
    )
    func showContext(in reply: LemmyModel.ReplyView)
    func reply(to reply: LemmyModel.ReplyView)
    func onLinkTap(in userMention: LemmyModel.ReplyView, url: URL)
    func showMoreAction(in reply: LemmyModel.ReplyView)
}

protocol UserMentionCellViewDelegate: AnyObject {
    func usernameTapped(with userMention: LemmyUserMention)
    func communityTapped(with userMention: LemmyCommunityMention)
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
    func showMoreAction(in userMention: LemmyModel.UserMentionView)
}
