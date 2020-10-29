//
//  CreateCommunityImagesCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 29.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CreateCommunityImagesCell: UITableViewCell {
    
    let iconView = LemmyLabelDownerImageView(imageName: "camera.circle.fill", labelText: "Icon")
    let bannerView = LemmyLabelDownerImageView(imageName: "camera.circle.fill", labelText: "Banner")
    
    init() {
        super.init(style: .default, reuseIdentifier: String(describing: Self.self))
        selectionStyle = .none
        
        let screenWidth = UIScreen.main.bounds.width
        
        [iconView, bannerView].forEach { (view) in
            contentView.addSubview(view)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(5)
            make.leading.equalToSuperview().inset(16)
            make.width.equalTo(screenWidth / 2.5)
        }
        
        bannerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(5)
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(screenWidth / 2.5)
            make.bottom.equalToSuperview().inset(5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LemmyLabelDownerImageView: UIView {
    let imageName: String
    let labelText: String
    
    lazy var iconTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = labelText
        lbl.font = .boldSystemFont(ofSize: 24)
        return lbl
    }()
    
    lazy var iconImageView: UIImageView = {
        let iv = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .black)
        
        iv.image = UIImage(systemName: imageName, withConfiguration: config)?
            .withTintColor(.label, renderingMode: .alwaysOriginal)
        iv.alpha = 0.5
        return iv
    }()
    
    init(imageName: String, labelText: String) {
        self.imageName = imageName
        self.labelText = labelText
        super.init(frame: .zero)
        
        [iconTitle, iconImageView].forEach { (view) in
            self.addSubview(view)
        }
        
        iconTitle.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(5)
        }
        
        iconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(iconTitle.snp.bottom).offset(10)
            make.size.equalTo(100)
            make.bottom.equalToSuperview().inset(5)
        }
        
        self.snp.makeConstraints { (make) in
            make.width.equalTo(iconImageView.snp.width)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
