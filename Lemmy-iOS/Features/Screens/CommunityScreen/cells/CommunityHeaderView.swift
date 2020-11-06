//
//  CommunityHeaderCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 02.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Nuke
import SwiftyMarkdown

class CommunityHeaderView: UIView {    
    
    let descriptionReadMoreButton = ResizableButton().then {
        $0.setTitle("Read more", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.backgroundColor = .systemBackground
    }
    
    let commImageView = UIImageView()
    
    let commNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 17, weight: .semibold)
    }
    
    let followButton = UIButton().then {
        $0.setTitle("Follow", for: .normal)
        $0.setTitleColor(.systemRed, for: .normal)
    }
    
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
        $0.textColor = .systemBlue
    }
    
    let categoryLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .systemBlue
    }
    
    let postsCountLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .systemBlue
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
        
        [commImageView, commNameLabel, UIView(), followButton].forEach { (view) in
            horizontalStackView.addArrangedSubview(view)
        }
        
        [communityDescriptionLabel, subscribersLabel, postsCountLabel, categoryLabel].forEach { (view) in
            verticalStackView.addArrangedSubview(view)
        }
        
        commImageView.snp.makeConstraints { (make) in
            make.size.equalTo(50)
        }
        
        horizontalStackView.snp.makeConstraints { (make) in
            make.height.equalTo(commImageView)
            make.top.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        communityDescriptionLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
        }
        
        verticalStackView.snp.makeConstraints { (make) in
            make.top.equalTo(horizontalStackView.snp.bottom).offset(5)
            make.leading.trailing.equalTo(horizontalStackView)
            make.bottom.equalTo(self.snp.bottom).inset(15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with data: LemmyModel.CommunityView) {
        if let commImageString = data.icon {
            Nuke.loadImage(with: URL(string: commImageString)!, into: commImageView)
        } else {
            commImageView.isHidden = true
        }
        
        commNameLabel.text = data.name
        subscribersLabel.text = String(data.numberOfSubscribers) + " Subscribers"
        categoryLabel.text = data.categoryName
        postsCountLabel.text = String(data.numberOfPosts) + " Posts"
        
        if let communityDesciption = data.description {
            communityDescriptionLabel.text = communityDesciption
            
            showReadMoreButtonIfTruncated(mdString: communityDesciption)
            
        } else {
            communityDescriptionLabel.isHidden = true
        }
    }
    
    fileprivate func showReadMoreButtonIfTruncated(mdString: String) {        
        if communityDescriptionLabel.isTruncated {
            
            self.addSubview(descriptionReadMoreButton)
            descriptionReadMoreButton.titleLabel?.textAlignment = .right
            
            descriptionReadMoreButton.snp.makeConstraints { (make) in
                make.trailing.equalTo(communityDescriptionLabel.snp.trailing)
                make.width.equalTo(descriptionReadMoreButton.intrinsicContentSize.width + 15)
                make.bottom.equalTo(communityDescriptionLabel.snp.bottom)
            }
        }
    }
}
