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
    func bind(with comment: LemmyModel.CommentView) {
        setupTargets(with: comment)

        headerView.bind(
            with: .init(
                avatarImageUrl: comment.creatorAvatar,
                username: comment.creatorName,
                community: comment.communityName,
                published: comment.published.shortTimeAgoSinceNow,
                score: comment.score,
                postName: comment.postName
            )
        )

        centerView.bind(with: .init(comment: comment.content))
        footerView.bind(with: CommentFooterView.ViewData(id: comment.id))

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

        // footer view
        footerView.showContextTap = { [weak self] in
            self?.delegate?.showContext(in: comment)
        }

        footerView.upvoteTap = { [weak self] in
            self?.delegate?.upvote(comment: comment)
        }

        footerView.downvoteTap = { [weak self] in
            self?.delegate?.downvote(comment: comment)
        }

        footerView.replyTap = { [weak self] in
            self?.delegate?.reply(to: comment)
        }

        footerView.showMoreTap = { [weak self] in
            self?.delegate?.showMoreAction(in: comment)
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
            make.top.leading.equalToSuperview().offset(16)     // SELF-SIZE TOP HERE
            make.bottom.trailing.equalToSuperview().inset(16)
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
            make.leading.trailing.bottom.equalToSuperview()     // SELF SIZE BOTTOM HERE
        }
    }
}
