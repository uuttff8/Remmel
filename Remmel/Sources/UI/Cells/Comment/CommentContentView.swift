//
//  CommentContentView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 27.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMModels

// MARK: - CommentContentView: UIView
class CommentContentView: UIView {

    enum Setting {
        case list // used in front page
        case inPost // used for viewing in post
    }
    
    // MARK: - Properties
    weak var delegate: CommentContentTableCellDelegate?

    private let paddingView = UIView()
    private let headerView = CommentHeaderView()
    private let centerView = CommentCenterView()
    private let footerView = CommentFooterView()
    private let separatorView = UIView.ViewPreConfigutations.separatorView
    
    private var currentSetting: Setting?

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
    func bind(with comment: RMModel.Views.CommentView, setting: Setting) {
        self.currentSetting = setting
        
        setupTargets(with: comment)

        headerView.bind(
            with: .init(
                avatarImageUrl: comment.creator.avatar,
                username: comment.creator.name,
                community: comment.community.name,
                published: comment.comment.published.toLocalTime().toRelativeDate(),
                score: comment.counts.score,
                postName: comment.post.name
            ),
            config: setting
        )

        centerView.bind(with: .init(comment: comment.comment.content, isDeleted: comment.comment.deleted))
        footerView.bind(
            with: .init(
                id: comment.comment.id,
                score: comment.counts.score,
                voteType: .down// comment.getVoteType()
            ),
            config: setting
        )
    }
    
    func updateForCreateCommentLike(comment: RMModel.Views.CommentView) {
        guard let setting = currentSetting else {
            debugPrint("Could not determine comment cell setting, so not updating comment like")
            return
        }
        
        footerView.bind(
            with: .init(
                id: comment.comment.id,
                score: comment.counts.score,
                voteType: .down //comment.getVoteType()
            ),
            config: setting
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
    private func setupTargets(with comment: RMModel.Views.CommentView) {
        
        // header view
        headerView.communityButtonTap = { [weak self] in
            let mention = LemmyCommunityMention(name: comment.community.name, id: comment.community.id)
            self?.delegate?.communityTapped(with: mention)
        }

        headerView.usernameButtonTap = { [weak self] in
            let mention = LemmyUserMention(string: comment.creator.name, id: comment.creator.id)
            self?.delegate?.usernameTapped(with: mention)
        }

        headerView.postNameButtonTap = { [weak self] in
            self?.delegate?.postNameTapped(in: comment)
        }
        
        headerView.showMoreTap = { [weak self] in
            self?.delegate?.showMoreAction(in: comment)
        }
        
        // center view
        centerView.onLinkTap = { [weak self] url in
            self?.delegate?.onLinkTap(in: comment, url: url)
        }
        
        centerView.onUserMentionTap = { [weak self] mention in
            self?.delegate?.usernameTapped(with: mention)
        }
        
        centerView.onCommunityMentionTap = { [weak self] mention in
            self?.delegate?.communityTapped(with: mention)
        }
        
        centerView.onImagePresent = { [weak self] vc in
            self?.delegate?.presentVc(viewController: vc)
        }

        // footer view
        footerView.showContextTap = { [weak self] in
            self?.delegate?.showContext(in: comment)
        }

        footerView.downvoteTap = { [weak self] scoreView, button, voteType in
            self?.delegate?.voteContent(scoreView: scoreView, voteButton: button, newVote: voteType, comment: comment)
        }
        
        footerView.upvoteTap = { [weak self] scoreView, button, voteType in
            self?.delegate?.voteContent(scoreView: scoreView, voteButton: button, newVote: voteType, comment: comment)
        }

        footerView.replyTap = { [weak self] in
            self?.delegate?.reply(to: comment)
        }
    }
}

extension CommentContentView: ProgrammaticallyViewProtocol {
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
            make.bottom.top.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        separatorView.snp.makeConstraints { make in
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
