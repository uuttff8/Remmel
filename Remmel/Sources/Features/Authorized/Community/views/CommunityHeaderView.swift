//
//  CommunityHeaderCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 02.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Nuke
import RMModels

protocol CommunityHeaderViewDelegate: AnyObject {
    func headerViewDidTapped(followButton: FollowButton, in community: RMModel.Views.CommunityView)
}

extension CommunityHeaderView {
    struct Appearance {
        let iconSize = CGSize(width: 50, height: 50)
    }
}

class CommunityHeaderView: UIView {
    
    weak var delegate: CommunityHeaderViewDelegate?
    
    let appearance = Appearance()
    
    var communityData: RMModel.Views.CommunityView?
    
    let descriptionReadMoreButton = ResizableButton().then {
        $0.setTitle("readmore-text".localized, for: .normal)
        $0.setTitleColor(.lemmyBlue, for: .normal)
        $0.backgroundColor = .systemBackground
    }
    
    let commImageView = UIImageView()
    
    let commNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 17, weight: .semibold)
    }
    
    let followButton = FollowButton()
    
    let horizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 8
    }
    
    let communityDescriptionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 17)
        $0.numberOfLines = 3
    }
    
    let subscribersLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .lemmyBlue
    }
    
    let categoryLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .lemmyBlue
    }
    
    let postsCountLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .lemmyBlue
    }
    
    let verticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 8
        $0.distribution = .fill
    }
    
    init() {
        super.init(frame: .zero)
        
        self.addSubview(horizontalStackView)
        self.addSubview(verticalStackView)
        
        [commImageView, commNameLabel, UIView(), followButton].forEach { view in
            horizontalStackView.addArrangedSubview(view)
        }
        
        [communityDescriptionLabel, subscribersLabel, postsCountLabel, categoryLabel].forEach { view in
            verticalStackView.addArrangedSubview(view)
        }
        
        commImageView.snp.makeConstraints { make in
            make.size.equalTo(appearance.iconSize)
        }
        
        horizontalStackView.snp.makeConstraints { make in
            make.height.equalTo(commImageView)
            make.top.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview()
        }
        
        communityDescriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(horizontalStackView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(horizontalStackView)
            make.bottom.equalTo(self.snp.bottom).inset(5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with data: RMModel.Views.CommunityView) {
        self.communityData = data
        commImageView.loadImage(urlString: data.community.icon, imageSize: appearance.iconSize)
        
        commNameLabel.text = data.community.name
        subscribersLabel.text = String(data.counts.subscribers) + " " + "community-subscribers".localized
        postsCountLabel.text = String(data.counts.posts) + " " + "content-posts".localized
        self.followButton.bind(isSubcribed: data.subscribed)
        
        if let communityDesciption = data.community.description {
            communityDescriptionLabel.text = communityDesciption.removeNewLines()
            showReadMoreButtonIfTruncated(mdString: communityDesciption)
            
        } else {
            communityDescriptionLabel.isHidden = true
        }
        
        followButton.addTarget(self, action: #selector(followButtonDidTapped), for: .touchUpInside)
    }
    
    func updateFollowingState(isSubscribed: Bool?) {
        followButton.bind(isSubcribed: isSubscribed)
    }
    
    fileprivate func showReadMoreButtonIfTruncated(mdString: String) {
        if communityDescriptionLabel.isTruncated {
            
            self.addSubview(descriptionReadMoreButton)
            descriptionReadMoreButton.titleLabel?.textAlignment = .right
            
            descriptionReadMoreButton.snp.makeConstraints { make in
                make.trailing.equalTo(communityDescriptionLabel.snp.trailing)
                make.width.equalTo(descriptionReadMoreButton.intrinsicContentSize.width + 15)
                make.bottom.equalTo(communityDescriptionLabel.snp.bottom)
            }
        }
    }
    
    @objc func followButtonDidTapped(_ sender: FollowButton) {
        guard let community = communityData else {
            return
        }
        self.delegate?.headerViewDidTapped(followButton: sender, in: community)
    }
}
