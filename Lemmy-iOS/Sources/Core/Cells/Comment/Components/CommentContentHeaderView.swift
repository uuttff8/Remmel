//
//  CommentContentHeaderView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 27.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Nuke

// MARK: - CommentHeaderView: UIView
class CommentHeaderView: UIView {

    // MARK: - ViewData
    struct ViewData {
        let avatarImageUrl: String?
        let username: String
        let community: String
        let published: String
        let score: Int
        let postName: String
    }

    // MARK: - Properties
    var communityButtonTap: (() -> Void)?
    var usernameButtonTap: (() -> Void)?
    var postNameButtonTap: (() -> Void)?
    var showMoreTap: (() -> Void)?

    private let imageSize = CGSize(width: 32, height: 32)

    lazy var avatarImageView = UIImageView().then {
        $0.layer.cornerRadius = imageSize.width / 2
        $0.layer.masksToBounds = false
        $0.clipsToBounds = true
    }

    let usernameButton = ResizableButton().then {
        $0.setTitleColor(UIColor.lemmyBlue, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    let communityButton = ResizableButton().then {
        $0.setTitleColor(UIColor.lemmyCommunity, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }

    let scoreLabel = UILabel()

    let publishedTitle = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = UIColor.lemmySecondLabel
    }

    let postNameButton: LabelControl = {
        $0.titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.titleLabel.textColor = UIColor.lemmyBlue
        $0.titleLabel.lineBreakMode = .byTruncatingTail
        $0.contentHorizontalAlignment = .left
        $0.titleLabel.numberOfLines = 0
        return $0
    }(LabelControl())
    
    private let dotTitle = UILabel().then {
        $0.text = " · "
        $0.textColor = UIColor.lemmySecondLabel
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    private let byTitle = UILabel().then {
        $0.text = "by"
        $0.textColor = .lemmySecondLabel
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    private let showMoreButton = IncreasedTapAreaButton().then {
        let image = Config.Image.ellipsis
        $0.setImage(image, for: .normal)
    }
    
    private let bottomInnerStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 2
    }
    
    private let lineStackView = UIStackView().then {
        $0.alignment = .center
        $0.axis = .horizontal
    }
    
    private let lineInnerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
    }
        
    private let infoStackView = UIStackView().then {
        $0.alignment = .leading
        $0.spacing = 8
        $0.axis = .horizontal
    }
    
    private let mainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 8
    }

    private let hapticGenerator = UIImpactFeedbackGenerator(style: .light)

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupButtonTargets()
        
        setupView()
        addSubviews()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public API
    func bind(with comment: CommentHeaderView.ViewData, config: CommentContentView.Setting) {
        let usernameButtonText = "@" + comment.username
        let communityButtonText = "!" + comment.community
        
        usernameButton.setTitle(usernameButtonText, for: .normal)
        communityButton.setTitle(communityButtonText, for: .normal)
        avatarImageView.loadImage(urlString: comment.avatarImageUrl)
        publishedTitle.text = comment.published
        scoreLabel.set(text: String(comment.score), leftIcon: Config.Image.boltFill)
        postNameButton.titleLabel.text = comment.postName
        
        setup(for: config)
    }
    
    func prepareForReuse() {
        usernameButton.setTitle(nil, for: .normal)
        communityButton.setTitle(nil, for: .normal)
        publishedTitle.text = nil
        postNameButton.titleLabel.text = nil
        avatarImageView.image = nil
    }
    
    func setup(for config: CommentContentView.Setting) {
        
        switch config {
        case .inPost:
            postNameButton.removeFromSuperview()
        case .list:
            break
        }
    }

    private func setupButtonTargets() {
        usernameButton.addTarget(self, action: #selector(usernameButtonTapped(sender:)), for: .touchUpInside)
        communityButton.addTarget(self, action: #selector(communityButtonTapped(sender:)), for: .touchUpInside)
        postNameButton.addTarget(self, action: #selector(postNameButtonTapped(sender:)), for: .touchUpInside)
        showMoreButton.addTarget(self, action: #selector(showMoreButtonTapped(sender:)), for: .touchUpInside)
    }

    @objc private func communityButtonTapped(sender: UIButton!) {
        communityButtonTap?()
    }

    @objc private func usernameButtonTapped(sender: UIButton!) {
        usernameButtonTap?()
    }

    @objc private func postNameButtonTapped(sender: UIButton!) {
        postNameButtonTap?()
    }
    
    @objc private func showMoreButtonTapped(sender: UIButton!) {
        self.hapticGenerator.prepare()
        self.hapticGenerator.impactOccurred()
        showMoreTap?()
    }
}

extension CommentHeaderView: ProgrammaticallyViewProtocol {
    func setupView() { }
    
    func addSubviews() {
        bottomInnerStackView.addStackViewItems(
            .view(byTitle),
            .view(usernameButton),
            .view(dotTitle),
            .view(publishedTitle)
        )
        
        lineInnerStackView.addStackViewItems(
            .view(communityButton),
            .view(bottomInnerStackView)
        )
        
        lineStackView.addStackViewItems(
            .view(lineInnerStackView),
            .view(UIView()),
            .view(showMoreButton)
        )
        
        infoStackView.addStackViewItems(
            .view(avatarImageView),
            .view(lineStackView)
        )
        
        mainStackView.addStackViewItems(
            .view(infoStackView),
            .view(postNameButton)
        )
        
        self.addSubview(mainStackView)
    }
    
    func makeConstraints() {
        
        avatarImageView.snp.makeConstraints { (make) in
            make.size.equalTo(imageSize.height)
        }
        
        infoStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        
        postNameButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        
        mainStackView.snp.makeConstraints { (make) in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}
