//
//  CommentContentFooterView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 27.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMModels

// MARK: - CommentFooterView: UIView
class CommentFooterView: UIView {
    
    var showContextTap: (() -> Void)?
    var upvoteTap: ((VoteButtonsWithScoreView, VoteButton, LemmyVoteType) -> Void)?
    var downvoteTap: ((VoteButtonsWithScoreView, VoteButton, LemmyVoteType) -> Void)?
    var replyTap: (() -> Void)?

    // MARK: - Constants
    private let iconSize = CGSize(width: 20, height: 20)

    // MARK: - Data
    struct ViewData {
        let id: Int
        let score: Int
        let voteType: LemmyVoteType
    }

    // MARK: - UI Elements
    private let showContextButton = UIButton().then {
        let image = Config.Image.link
        $0.setImage(image, for: .normal)
    }
    
    private let upvoteDownvoteButtons = VoteButtonsWithScoreView()

    private let replyButton = UIButton().then {
        let image = Config.Image.arrowshapeTurnUp
        $0.setImage(image, for: .normal)
    }

    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 20
    }
    
    private let hapticGenerator = UIImpactFeedbackGenerator(style: .light)

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupTargets()
        
        setupView()
        addSubviews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public
    func bind(with data: CommentFooterView.ViewData, config: CommentContentView.Setting) {
        setup(for: config)
        upvoteDownvoteButtons.bind(with: .init(score: data.score, voteType: data.voteType))
    }
    
    func prepareForReuse() { }
    
    func setup(for config: CommentContentView.Setting) {
        switch config {
        case .inPost:
            showContextButton.removeFromSuperview()
        case .list: break
        }
    }

    // MARK: - Overrided
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        replyButton.setImage(Config.Image.arrowshapeTurnUp, for: .normal)
        showContextButton.setImage(Config.Image.link, for: .normal)
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: 30)
    }

    // MARK: - Private
    private func setupTargets() {
        showContextButton.addTarget(self, action: #selector(showContextButtonTapped(sender:)), for: .touchUpInside)
        upvoteDownvoteButtons.upvoteButtonTap = {
            self.hapticGenerator.prepare()
            self.hapticGenerator.impactOccurred()
            self.upvoteTap?($0, $1, $2)
        }
        upvoteDownvoteButtons.downvoteButtonTap = {
            self.hapticGenerator.prepare()
            self.hapticGenerator.impactOccurred()
            self.downvoteTap?($0, $1, $2)
        }
        replyButton.addTarget(self, action: #selector(replyButtonTapped(sender:)), for: .touchUpInside)
    }

    @objc private func showContextButtonTapped(sender: UIButton!) {
        showContextTap?()
    }

    @objc private func replyButtonTapped(sender: UIButton!) {
        replyTap?()
    }
}

extension CommentFooterView: ProgrammaticallyViewProtocol {
    func setupView() { }
    
    func addSubviews() {
        self.addSubview(stackView)
        
        stackView.addStackViewItems(
            .view(upvoteDownvoteButtons),
            .view(UIView()),
            .view(replyButton),
            .view(showContextButton) // deleted if in post
        )
    }
    
    func makeConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        [showContextButton, replyButton].forEach { btn in
            btn.snp.makeConstraints { make in
                make.height.equalTo(22)
                make.width.equalTo(22)
            }
        }
    }
}
