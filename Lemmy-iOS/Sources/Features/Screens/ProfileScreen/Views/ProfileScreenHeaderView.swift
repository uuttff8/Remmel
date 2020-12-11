//
//  ProfileScreenHeaderView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Nuke

extension ProfileScreenHeaderView {
    struct Appearance {
        let imageFadeInDuration: TimeInterval = 0.15
        let overlayAlpha: CGFloat = 0.75
        let additionalStackViewSpacing: CGFloat = 8.0
        let iconSize = CGSize(width: 50, height: 50)
        let bannerSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 8)
        
        let defaultSpacing: CGFloat = 10
    }
}

class ProfileScreenHeaderView: UIView {
    
    struct ViewData {
        let name: String
        let avatarUrl: String?
        let bannerUrl: String?
        let numberOfComments: Int
        let numberOfPosts: Int
        let published: Date
    }
    
    let appearance: Appearance
    
    private let bannerImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var mainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = self.appearance.defaultSpacing
    }
    
    private lazy var imageTitleStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = self.appearance.defaultSpacing
    }

    private lazy var iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = appearance.iconSize.width / 2
        $0.clipsToBounds = true
    }
    
    private let usernameLabel = UILabel()
    
    private lazy var additionalInfoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = self.appearance.defaultSpacing
        $0.distribution = .fill
    }
    
    private let numberOfPostsLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .systemBlue
    }
    
    private let numberOfCommentsLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .systemBlue
    }
    
    private let pubslihedLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .systemBlue
    }

    init(
        frame: CGRect = .zero,
        scrollDelegate: UIScrollViewDelegate? = nil,
        appearance: Appearance = Appearance()
    ) {
        self.appearance = appearance
        super.init(frame: frame)
        
        self.setupView()
        self.addSubviews()
        self.makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // All elements have fixed height
    func calculateHeight() -> CGFloat {
        let mainStackViewContentSize = self.mainStackView
            .systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        return mainStackViewContentSize.height
            + (self.appearance.defaultSpacing * 2) //imageTitle
            + (self.appearance.defaultSpacing) // comments, posts, published titles
    }
    
    func configure(viewData: ViewData) {
        usernameLabel.text = viewData.name
        iconImageView.loadImage(urlString: viewData.avatarUrl)
        bannerImageView.loadImage(urlString: viewData.bannerUrl)
        numberOfCommentsLabel.text = String(viewData.numberOfComments) + " Comments"
        numberOfPostsLabel.text = String(viewData.numberOfPosts) + " Posts"
        pubslihedLabel.text = "Joined " + String(viewData.published.shortTimeAgoSinceNow) + " ago"
    }
}

extension ProfileScreenHeaderView: ProgrammaticallyViewProtocol {
    func setupView() {
        self.clipsToBounds = true
        self.backgroundColor = .systemBackground
    }

    func addSubviews() {
        self.addSubview(bannerImageView)
        self.addSubview(mainStackView)
        
        mainStackView.addStackViewItems(
            .view(imageTitleStackView),
            .view(additionalInfoStackView)
        )
        
        additionalInfoStackView.addStackViewItems(
            .view(numberOfPostsLabel),
            .view(numberOfCommentsLabel),
            .view(pubslihedLabel)
        )
        
        imageTitleStackView.addStackViewItems(
            .view(iconImageView),
            .view(usernameLabel)
        )
    }

    func makeConstraints() {
        self.bannerImageView.snp.makeConstraints {
            $0.size.equalTo(appearance.bannerSize)
            $0.top.leading.trailing.equalToSuperview()
        }
        
        self.iconImageView.snp.makeConstraints {
            $0.size.equalTo(appearance.iconSize)
        }
        
        self.mainStackView.snp.makeConstraints {
            $0.top.equalTo(bannerImageView.snp.bottom)
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
    }
}
