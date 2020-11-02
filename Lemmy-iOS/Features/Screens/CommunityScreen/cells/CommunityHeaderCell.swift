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

class CommunityHeaderCell: UITableViewCell {
    
    let commImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    let commNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 15, weight: .semibold)
        return lbl
    }()
    
    let followButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Follow", for: .normal)
        btn.setTitleColor(.systemRed, for: .normal)
        return btn
    }()
    
    let horizontalStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 8
        return sv
    }()
    
    let communityDescriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 17)
        lbl.numberOfLines = 3
        return lbl
    }()
    
    let subscribersLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14)
        lbl.textColor = .systemBlue
        return lbl
    }()
    
    let categoryLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14)
        lbl.textColor = .systemBlue
        return lbl
    }()
    
    let postsCountLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14)
        lbl.textColor = .systemBlue
        return lbl
    }()
    
    let verticalStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .leading
        sv.spacing = 8
        return sv
    }()

    init() {
        super.init(style: .default, reuseIdentifier: String(describing: Self.self))
        
        contentView.addSubview(horizontalStackView)
        contentView.addSubview(verticalStackView)
        
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
        
        verticalStackView.snp.makeConstraints { (make) in
            make.top.equalTo(horizontalStackView.snp.bottom).offset(5)
            make.leading.trailing.equalTo(horizontalStackView)
            make.bottom.equalTo(contentView.snp.bottom).inset(5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with data: LemmyApiStructs.CommunityView) {
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
//            let md = SwiftyMarkdown(string: communityDesciption)
            communityDescriptionLabel.text = communityDesciption
            
            showReadMoreButtonIfTruncated()
            
        } else {
            communityDescriptionLabel.isHidden = true
        }
    }
    
    fileprivate func showReadMoreButtonIfTruncated() {
        if communityDescriptionLabel.isTruncated {
            
            let descriptionReadMoreButton: UILabel = {
                let lbl = UILabel()
                lbl.text = "Read more"
                lbl.textColor = .systemBlue
                lbl.backgroundColor = .systemBackground
                return lbl
            }()
            
            descriptionReadMoreButton.addTap {
                // TODO(uuttff8): present separate with md-rendered desciption
                fatalError("present separate with md-rendered desciption")
            }
            
            communityDescriptionLabel.addSubview(descriptionReadMoreButton)
            descriptionReadMoreButton.textAlignment = .right
            descriptionReadMoreButton.snp.makeConstraints { (make) in
                make.trailing.equalToSuperview()
                make.width.equalTo(descriptionReadMoreButton.intrinsicContentSize.width + 15)
                make.bottom.equalToSuperview()
            }
        }
    }

}
