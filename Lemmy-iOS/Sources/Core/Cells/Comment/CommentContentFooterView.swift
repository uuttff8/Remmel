//
//  CommentContentFooterView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 27.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

// MARK: - CommentFooterView: UIView
class CommentFooterView: UIView {
    var showContextTap: (() -> Void)?
    var upvoteTap: (() -> Void)?
    var downvoteTap: (() -> Void)?
    var replyTap: (() -> Void)?
    var showMoreTap: (() -> Void)?

    // MARK: - Constants
    private let iconSize = CGSize(width: 20, height: 20)

    // MARK: - Data
    struct ViewData {
        let id: Int
    }

    // MARK: - UI Elements
    private let showContextButton = UIButton().then {
        let image = Config.Image.link
        $0.setImage(image, for: .normal)
    }

    private let upvoteButton = UIButton().then {
        let image = Config.Image.arrowUp
        $0.setImage(image, for: .normal)
    }
    
    private let downvoteButton = UIButton().then {
        let image = Config.Image.arrowDown
        $0.setImage(image, for: .normal)
    }

    private let replyButton = UIButton().then {
        let image = Config.Image.arrowshapeTurnUp
        $0.setImage(image, for: .normal)
    }

    private let showMoreButton = UIButton().then {
        let image = Config.Image.ellipsis
        $0.setImage(image, for: .normal)
    }

    private let stackView = UIStackView().then {
        $0.alignment = .center
        $0.spacing = 40
    }

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
    func bind(with: CommentFooterView.ViewData) { }
    
    func prepareForReuse() { }

    // MARK: - Overrided
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        replyButton.setImage(Config.Image.arrowshapeTurnUp, for: .normal)
        showMoreButton.setImage(Config.Image.ellipsis, for: .normal)
        upvoteButton.setImage(Config.Image.arrowUp, for: .normal)
        downvoteButton.setImage(Config.Image.arrowDown, for: .normal)
        showContextButton.setImage(Config.Image.link, for: .normal)
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: 30)
    }

    // MARK: - Private
    private func setupTargets() {
        showContextButton.addTarget(self, action: #selector(showContextButtonTapped(sender:)), for: .touchUpInside)
        upvoteButton.addTarget(self, action: #selector(upvoteButtonTapped(sender:)), for: .touchUpInside)
        downvoteButton.addTarget(self, action: #selector(downvoteButtonTapped(sender:)), for: .touchUpInside)
        replyButton.addTarget(self, action: #selector(replyButtonTapped(sender:)), for: .touchUpInside)
        showMoreButton.addTarget(self, action: #selector(showMoreButtonTapped(sender:)), for: .touchUpInside)
    }

    @objc private func showContextButtonTapped(sender: UIButton!) {
        showContextTap?()
    }

    @objc private func upvoteButtonTapped(sender: UIButton!) {
        upvoteTap?()
    }

    @objc private func downvoteButtonTapped(sender: UIButton!) {
        downvoteTap?()
    }

    @objc private func replyButtonTapped(sender: UIButton!) {
        replyTap?()
    }

    @objc private func showMoreButtonTapped(sender: UIButton!) {
        showMoreTap?()
    }
}

extension CommentFooterView: ProgrammaticallyViewProtocol {
    func setupView() { }
    
    func addSubviews() {
        self.addSubview(stackView)
    }
    
    func makeConstraints() {
        stackView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
        }
        
        [showContextButton, upvoteButton, downvoteButton, replyButton, showMoreButton].forEach { (btn) in
            self.stackView.addArrangedSubview(btn)

            btn.snp.makeConstraints { (make) in
                make.height.equalTo(20)
                make.width.equalTo(20)
            }
        }

        self.stackView.addArrangedSubview(UIView())
    }
}
