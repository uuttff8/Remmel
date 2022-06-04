//
//  ReplyTableCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 07.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

// MARK: - ReplyMentionCellView: UIView
class ReplyMentionCellView: UIView {

    enum Setting {
        case list // used in front page
        case inPost // used for viewing in post
    }
    
    // MARK: - Properties
    weak var replyDelegate: ReplyCellViewDelegate?
    weak var mentionDelegate: UserMentionCellViewDelegate?

    private let paddingView = UIView()
    private let headerView = CommentHeaderView()
    private let centerView = CommentCenterView()
    private let footerView = CommentFooterView()
    private let separatorView = UIView.ViewPreConfigutations.separatorView

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        setupView()
        addSubviews()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public API
    func configure(reply: LMModels.Views.CommentView) {
        setupTargets(with: reply)

        headerView.bind(
            with: .init(
                avatarImageUrl: reply.creator.avatar,
                username: reply.creator.name,
                community: reply.community.name,
                published: reply.comment.published.toLocalTime().shortTimeAgoSinceNow,
                score: reply.counts.score,
                postName: reply.post.name
            ),
            config: .list
        )

        centerView.bind(with: .init(comment: reply.comment.content, isDeleted: reply.comment.deleted))
        footerView.bind(
            with: .init(
                id: reply.comment.id,
                score: reply.counts.score,
                voteType: reply.getVoteType()
            ),
            config: .list
        )
    }
    
    func configure(mention: LMModels.Views.PersonMentionView) {
        setupTargets(with: mention)

        headerView.bind(
            with: .init(
                avatarImageUrl: mention.creator.avatar,
                username: mention.creator.name,
                community: mention.community.name,
                published: mention.comment.published.toLocalTime().shortTimeAgoSinceNow,
                score: mention.counts.score,
                postName: mention.post.name
            ),
            config: .list
        )

        centerView.bind(with: .init(comment: mention.comment.content, isDeleted: mention.comment.deleted))
        footerView.bind(
            with: .init(
                id: mention.id,
                score: mention.counts.score,
                voteType: mention.getVoteType()
            ),
            config: .list
        )

    }
    
    func prepareForReuse() {
        headerView.prepareForReuse()
        centerView.prepareForReuse()
        footerView.prepareForReuse()
    }

    // MARK: - Overrided
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.separatorView.backgroundColor = Config.Color.separator
    }

    // MARK: - Private
    private func setupTargets(with reply: LMModels.Views.CommentView) {
        
        // header view
        headerView.communityButtonTap = { [weak self] in
            let mention = LemmyCommunityMention(name: reply.community.name, id: reply.community.id)
            self?.replyDelegate?.communityTapped(with: mention)
        }

        headerView.usernameButtonTap = { [weak self] in
            let mention = LemmyUserMention(string: reply.creator.name, id: reply.creator.id)
            self?.replyDelegate?.usernameTapped(with: mention)
        }

        headerView.postNameButtonTap = { [weak self] in
            self?.replyDelegate?.postNameTapped(in: reply)
        }
        
        headerView.showMoreTap = { [weak self] in
            self?.replyDelegate?.showMoreAction(in: reply)
        }
        
        // center view
        centerView.onLinkTap = { [weak self] url in
            self?.replyDelegate?.onLinkTap(in: reply, url: url)
        }
        
        centerView.onUserMentionTap = { [weak self] mention in
            self?.replyDelegate?.usernameTapped(with: mention)
        }
        
        centerView.onCommunityMentionTap = { [weak self] mention in
            self?.replyDelegate?.communityTapped(with: mention)
        }

        // footer view
        footerView.showContextTap = { [weak self] in
            self?.replyDelegate?.showContext(in: reply)
        }

        footerView.downvoteTap = { [weak self] scoreView, button, voteType in
            self?.replyDelegate?.voteContent(scoreView: scoreView, voteButton: button, newVote: voteType, reply: reply)
        }
        
        footerView.upvoteTap = { [weak self] scoreView, button, voteType in
            self?.replyDelegate?.voteContent(scoreView: scoreView, voteButton: button, newVote: voteType, reply: reply)
        }

        footerView.replyTap = { [weak self] in
            self?.replyDelegate?.reply(to: reply)
        }
    }
    
    private func setupTargets(with mention: LMModels.Views.PersonMentionView) {
        
        // header view
        headerView.communityButtonTap = { [weak self] in
            let mention = LemmyCommunityMention(name: mention.community.name)
            self?.mentionDelegate?.communityTapped(with: mention)
        }

        headerView.usernameButtonTap = { [weak self] in
            let mention = LemmyUserMention(string: mention.creator.name)
            self?.mentionDelegate?.usernameTapped(with: mention)
        }

        headerView.postNameButtonTap = { [weak self] in
            self?.mentionDelegate?.postNameTapped(in: mention)
        }
        
        headerView.showMoreTap = { [weak self] in
            self?.mentionDelegate?.showMoreAction(in: mention)
        }
        
        // center view
        centerView.onLinkTap = { [weak self] url in
            self?.mentionDelegate?.onLinkTap(in: mention, url: url)
        }
        
        centerView.onUserMentionTap = { [weak self] mention in
            self?.mentionDelegate?.usernameTapped(with: mention)
        }
        
        centerView.onCommunityMentionTap = { [weak self] mention in
            self?.mentionDelegate?.communityTapped(with: mention)
        }

        // footer view
        footerView.showContextTap = { [weak self] in
            self?.mentionDelegate?.showContext(in: mention)
        }

        footerView.downvoteTap = { [weak self] scoreView, button, voteType in
            self?.mentionDelegate?.voteContent(scoreView: scoreView,
                                               voteButton: button,
                                               newVote: voteType,
                                               userMention: mention)
        }
        
        footerView.upvoteTap = { [weak self] scoreView, button, voteType in
            self?.mentionDelegate?.voteContent(scoreView: scoreView,
                                               voteButton: button,
                                               newVote: voteType,
                                               userMention: mention)
        }

        footerView.replyTap = { [weak self] in
            self?.mentionDelegate?.reply(to: mention)
        }
    }

}

extension ReplyMentionCellView: ProgrammaticallyViewProtocol {
    func setupView() {
        
    }
    
    func addSubviews() {
        self.addSubview(paddingView)
        self.addSubview(separatorView)
        
        paddingView.addSubview(headerView)
        paddingView.addSubview(centerView)
        paddingView.addSubview(footerView)
    }
    
    func makeConstraints() {
        paddingView.snp.makeConstraints { make in
            make.bottom.top.equalToSuperview().inset(5) // SELF-SIZE TOP HERE
            make.leading.trailing.equalToSuperview().inset(16) // SELF SIZE BOTTOM HERE
        }
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
            make.leading.equalToSuperview().offset(10)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        centerView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(5)
            make.trailing.leading.equalToSuperview()
        }
        
        footerView.snp.makeConstraints { make in
            make.top.equalTo(centerView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
