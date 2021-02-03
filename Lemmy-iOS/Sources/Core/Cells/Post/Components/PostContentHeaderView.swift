//
//  PostContentHeaderView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 01.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Nuke

// MARK: - PostContentHeaderView: UIView
class PostContentHeaderView: UIView {
    
    // MARK: - Data
    struct ViewData {
        let avatarImageUrl: String?
        let username: String
        let community: String
        let published: String
        let urlDomain: String?
    }
    
    // MARK: - Properties
    var communityButtonTap: (() -> Void)?
    var usernameButtonTap: (() -> Void)?
    var showMoreButtonTap: (() -> Void)?
    
    private let imageSize = CGSize(width: 32, height: 32)
    
    lazy var avatarImageView = UIImageView().then {
        $0.layer.cornerRadius = imageSize.width / 2
        $0.layer.masksToBounds = false
        $0.clipsToBounds = true
    }
    
    private let usernameButton = ResizableButton().then {
        $0.setTitleColor(UIColor.lemmyBlue, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    private let communityButton = ResizableButton().then {
        $0.setTitleColor(UIColor.lemmyCommunity, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
    }
    
    private let publishedTitle = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .lemmySecondLabel
    }
    
    private let showMoreButton = IncreasedTapAreaButton().then {
        let image = Config.Image.ellipsis
        $0.setImage(image, for: .normal)
    }
    
    private let byTitle = UILabel().then {
        $0.text = "by"
        $0.textColor = .lemmySecondLabel
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    private let dotTitle = UILabel().then {
        $0.text = " · "
        $0.textColor = UIColor.lemmySecondLabel
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    lazy var urlDomainTitle = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    private let userCommunityStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
    }
    
    private let bottomStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .leading
        $0.spacing = 2
    }
    
    private let mainStackView = UIStackView().then {
        $0.alignment = .center
        $0.spacing = 8
    }
    
    private let hapticGenerator = UIImpactFeedbackGenerator(style: .light)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
                
        setupView()
        addSubviews()
        makeConstraints()
        setupTargets()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    func bind(config: PostContentType, with data: PostContentHeaderView.ViewData) {
        let usernameButtonText = "@" + data.username
        let communityButtonText = "!" + data.community
        
        usernameButton.setTitle(usernameButtonText, for: .normal)
        communityButton.setTitle(communityButtonText, for: .normal)
        publishedTitle.text = data.published
        
        avatarImageView.loadImage(urlString: data.avatarImageUrl, imageSize: imageSize)
        
        switch config {
        case .insideComminity:
            byTitle.isHidden = true
            communityButton.isHidden = true
        default: break
        }
    }
    
    // MARK: - Private
    private func setupTargets() {
        usernameButton.addTarget(self, action: #selector(usernameButtonTapped(sender:)), for: .touchUpInside)
        communityButton.addTarget(self, action: #selector(communityButtonTapped(sender:)), for: .touchUpInside)
        showMoreButton.addTarget(self, action: #selector(showMoreButtonTapped(sender:)), for: .touchUpInside)
    }
    
    @objc private func usernameButtonTapped(sender: UIButton!) {
        usernameButtonTap?()
    }
    
    @objc private func communityButtonTapped(sender: UIButton!) {
        communityButtonTap?()
    }
    
    @objc private func showMoreButtonTapped(sender: UIButton!) {
        self.hapticGenerator.prepare()
        self.hapticGenerator.impactOccurred()
        showMoreButtonTap?()
    }
            
    func prepareForReuse() {
        avatarImageView.image = nil
        publishedTitle.text = nil
        urlDomainTitle.text = nil
        usernameButton.setTitle(nil, for: .normal)
        communityButton.setTitle(nil, for: .normal)
        byTitle.isHidden = false
        communityButton.isHidden = false
        avatarImageView.isHidden = false
    }
    
    // MARK: - Overrided
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: 30)
    }
}

extension PostContentHeaderView: ProgrammaticallyViewProtocol {
    func setupView() {
    }
    
    func addSubviews() {
        self.addSubview(mainStackView)
        
        bottomStackView.addStackViewItems(
            .view(byTitle),
            .view(usernameButton),
            .view(dotTitle),
            .view(publishedTitle)
        )
        
        userCommunityStackView.addStackViewItems(
            .view(communityButton),
            .view(bottomStackView)
        )
        
        mainStackView.addStackViewItems(
            .view(avatarImageView),
            .view(userCommunityStackView),
            .view(showMoreButton)
        )
    }
    
    func makeConstraints() {
        avatarImageView.snp.makeConstraints {
            $0.size.equalTo(imageSize)
        }
        
        mainStackView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}
