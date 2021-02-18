//
//  CommunityPreviewCellView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 23.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol CommunityPreviewCellViewDelegate: AnyObject {
    func communityCellView(_ cell: CommunityPreviewCellView, didTapped followButton: FollowButton)
}

final class CommunityPreviewCellView: UIView {
    struct ViewData {
        let id: Int
        let imageUrl: URL?
        let name: String
        let category: String
        let subscribers: Int
    }
    
    public var viewData: ViewData?
    
    weak var delegate: CommunityPreviewCellViewDelegate?
    
    private let iconSize = CGSize(width: 20, height: 20)
    
    private let communityImageView = UIImageView().then {
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    private let communityNameLabel = UILabel()
    private let categoryLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .light)
        $0.textColor = .lemmyBlue
    }
    private let subscribersLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .light)
        $0.textColor = .lemmyBlue
    }
    private let postsLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .light)
        $0.textColor = .lemmyBlue
    }
    private let commentsLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .light)
        $0.textColor = .lemmyBlue
    }
    
    private let followButton = FollowButton()
    
    private let originalInstanceLabel: UILabel = {
        $0.font = .systemFont(ofSize: 14, weight: .light)
        $0.textColor = UIColor.lemmySecondLabel
        return $0
    }(UILabel())
    
    private let headerStackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 5
        return $0
    }(UIStackView())
    
    private let mainStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 3
        return $0
    }(UIStackView())
    
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
    
    func configure(with community: LMModels.Views.CommunityView) {
        self.viewData = ViewData(id: community.id,
                                 imageUrl: community.community.icon,
                                 name: community.community.name,
                                 category: community.category.name,
                                 subscribers: community.counts.subscribers)
        
        self.communityImageView.loadImage(urlString: community.community.icon)
        
        self.originalInstanceLabel.text =  "@" + community.community.originalInstance
        self.communityNameLabel.text = "!" + community.community.name
        self.subscribersLabel.text = String(community.counts.subscribers) + " " + "community-subscribers".localized
        self.commentsLabel.text = String(community.counts.comments) + " " + "community-users".localized
        self.postsLabel.text = String(community.counts.posts) + " " + "Posts".localized
        self.categoryLabel.text = community.category.name
        
        self.followButton.bind(isSubcribed: community.subscribed)
        
        followButton.addTarget(self, action: #selector(followButtonTapped(sender:)), for: .touchUpInside)
    }
    
    @objc
    private func followButtonTapped(sender: FollowButton) {
        self.delegate?.communityCellView(self, didTapped: sender)
    }
}

extension CommunityPreviewCellView: ProgrammaticallyViewProtocol {
    func setupView() { }
    
    func addSubviews() {
        self.headerStackView.addStackViewItems(
            .view(communityImageView),
            .view(communityNameLabel)
        )
        
        self.mainStackView.addStackViewItems(
            .view(originalInstanceLabel),
            .view(categoryLabel),
            .view(subscribersLabel),
            .view(postsLabel),
            .view(commentsLabel)
        )
        
        self.addSubview(headerStackView)
        self.addSubview(mainStackView)
        self.addSubview(followButton)
    }
    
    func makeConstraints() {
        
        self.communityImageView.snp.makeConstraints {
            $0.size.equalTo(self.iconSize)
        }
        
        headerStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5)
            $0.leading.equalToSuperview().inset(16)
        }
        
        mainStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalTo(headerStackView.snp.bottom)
            $0.bottom.equalToSuperview().inset(5)
        }
        
        followButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
    }
}
