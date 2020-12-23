//
//  CommentContentView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 27.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

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
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Config.Color.separator
        return view
    }()

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
    func bind(with comment: LemmyModel.CommentView, setting: Setting) {
        setupTargets(with: comment)

        headerView.bind(
            with: .init(
                avatarImageUrl: comment.creatorAvatar,
                username: comment.creatorName,
                community: comment.communityName,
                published: comment.published.shortTimeAgoSinceNow,
                score: comment.score,
                postName: comment.postName
            ),
            config: setting
        )

        centerView.bind(with: .init(comment: comment.content, isDeleted: comment.deleted))
        footerView.bind(
            with: .init(
                id: comment.id,
                score: comment.score,
                voteType: comment.getVoteType()
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
    private func setupTargets(with comment: LemmyModel.CommentView) {
        
        // header view
        headerView.communityButtonTap = { [weak self] in
            self?.delegate?.communityTapped(in: comment)
        }

        headerView.usernameButtonTap = { [weak self] in
            self?.delegate?.usernameTapped(in: comment)
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
        
        centerView.onMentionTap = { [weak self] mention in
            self?.delegate?.onMentionTap(in: comment, mention: mention)
        }

        // footer view
        footerView.showContextTap = { [weak self] in
            self?.delegate?.showContext(in: comment)
        }

        footerView.downvoteTap = { [weak self] (scoreView, button, voteType) in
            self?.delegate?.voteContent(scoreView: scoreView, voteButton: button, newVote: voteType, comment: comment)
        }
        
        footerView.upvoteTap = { [weak self] (scoreView, button, voteType) in
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
        paddingView.snp.makeConstraints { (make) in
            make.bottom.top.equalToSuperview().inset(5) // SELF-SIZE TOP HERE
            make.leading.trailing.equalToSuperview().inset(16) // SELF SIZE BOTTOM HERE
        }
        separatorView.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
            make.leading.equalToSuperview().offset(10)
        }
        
        headerView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
        }
        
        centerView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom).offset(5)
            make.trailing.leading.equalToSuperview()
        }
        
        footerView.snp.makeConstraints { (make) in
            make.top.equalTo(centerView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
