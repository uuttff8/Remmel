//
//  CreatePostCommunityCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 21.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CreatePostCommunityCell: UITableViewCell {
    
    private(set) lazy var viewPadding = UIView()
    
    private(set) lazy var communityImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    private(set) lazy var communityLabel: UILabel = {
        let lbl = UILabel()
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        let imageConfig = UIImage.SymbolConfiguration(scale: .small)
        communityImageView.image = UIImage(systemName: "person.3", withConfiguration: imageConfig)?
            .withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        communityLabel.text = "Choose community"
        
        contentView.addSubview(communityImageView)
        contentView.addSubview(communityLabel)
        contentView.addSubview(viewPadding)
        
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        communityImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(16)
            make.size.equalTo(35)
            make.bottom.equalToSuperview().inset(10)
        }
        
        communityLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(communityImageView.snp.trailing).offset(10)
        }
    }
}
