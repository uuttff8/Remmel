//
//  ReplyMentionProtocols.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 07.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMModels
import RMFoundation

protocol ReplyCellViewDelegate: AnyObject {
    func usernameTapped(with userMention: LemmyUserMention)
    func communityTapped(with userMention: LemmyCommunityMention)
    func postNameTapped(in reply: RMModels.Views.CommentView)
    func voteContent(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        newVote: LemmyVoteType,
        reply: RMModels.Views.CommentView
    )
    func showContext(in reply: RMModels.Views.CommentView)
    func reply(to reply: RMModels.Views.CommentView)
    func onLinkTap(in userMention: RMModels.Views.CommentView, url: URL)
    func showMoreAction(in reply: RMModels.Views.CommentView)
}

protocol UserMentionCellViewDelegate: AnyObject {
    func usernameTapped(with userMention: LemmyUserMention)
    func communityTapped(with userMention: LemmyCommunityMention)
    func postNameTapped(in userMention: RMModels.Views.PersonMentionView)
    func voteContent(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        newVote: LemmyVoteType,
        userMention: RMModels.Views.PersonMentionView
    )
    func showContext(in userMention: RMModels.Views.PersonMentionView)
    func reply(to userMention: RMModels.Views.PersonMentionView)
    func onLinkTap(in userMention: RMModels.Views.PersonMentionView, url: URL)
    func showMoreAction(in userMention: RMModels.Views.PersonMentionView)
}
