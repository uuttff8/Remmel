//
//  CreatePostCommunityCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 21.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Nuke

class CreatePostCommunityCell: UITableViewCell {
    struct ViewData {
        let title: String
        let imageView: String
    }
    
    private(set) lazy var communityImageView = UIImageView()
    private(set) lazy var communityLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .disclosureIndicator
        
        let imageConfig = UIImage.SymbolConfiguration(scale: .small)
        
        communityImageView.image = UIImage(
            systemName: "person.3",
            withConfiguration: imageConfig
        )?
        .withTintColor(.systemRed,
                       renderingMode: .alwaysOriginal)
        communityLabel.text = "Choose community"
        
        contentView.addSubview(communityImageView)
        contentView.addSubview(communityLabel)
        
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with data: LMModels.Views.CommunityView) {
        if let url = data.community.icon {
            Nuke.loadImage(with: ImageRequest(url: url), into: communityImageView)
        } else {
            self.communityImageView.isHidden = true
            
            communityLabel.snp.remakeConstraints { (make) in
                make.top.equalToSuperview().inset(10)
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().inset(16)
                make.trailing.equalToSuperview().inset(30)
            }
        }
        
        communityLabel.text = data.community.title
    }
    
    // MARK: - Private
    private func layoutUI() {
        communityImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(5)
            make.leading.equalToSuperview().inset(16)
            make.size.equalTo(35)
            make.bottom.equalToSuperview().inset(5)
        }
        
        communityLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(communityImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(30)
        }
    }
}
