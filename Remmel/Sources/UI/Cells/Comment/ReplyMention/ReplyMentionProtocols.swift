//
//  ReplyMentionProtocols.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 07.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMModels

protocol ReplyCellViewDelegate: AnyObject {
    func usernameTapped(with userMention: LemmyUserMention)
    func communityTapped(with userMention: LemmyCommunityMention)
    func postNameTapped(in reply: RMModel.Views.CommentView)
    func voteContent(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        newVote: LemmyVoteType,
        reply: RMModel.Views.CommentView
    )
    func showContext(in reply: RMModel.Views.CommentView)
    func reply(to reply: RMModel.Views.CommentView)
    func onLinkTap(in userMention: RMModel.Views.CommentView, url: URL)
    func showMoreAction(in reply: RMModel.Views.CommentView)
}

protocol UserMentionCellViewDelegate: AnyObject {
    func usernameTapped(with userMention: LemmyUserMention)
    func communityTapped(with userMention: LemmyCommunityMention)
    func postNameTapped(in userMention: RMModel.Views.PersonMentionView)
    func voteContent(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        newVote: LemmyVoteType,
        userMention: RMModel.Views.PersonMentionView
    )
    func showContext(in userMention: RMModel.Views.PersonMentionView)
    func reply(to userMention: RMModel.Views.PersonMentionView)
    func onLinkTap(in userMention: RMModel.Views.PersonMentionView, url: URL)
    func showMoreAction(in userMention: RMModel.Views.PersonMentionView)
}
