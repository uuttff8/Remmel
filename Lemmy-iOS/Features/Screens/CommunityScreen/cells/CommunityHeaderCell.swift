//
//  CommunityHeaderCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 02.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CommunityHeaderCell: UITableViewCell {
    
    let commImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    let commLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 15, weight: .semibold)
        return lbl
    }()
    
    let followButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Follow", for: .normal)
        return btn
    }()
    
    let horizontalStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 8
        return sv
    }()
    
    init() {
        super.init(style: .default, reuseIdentifier: String(describing: Self.self))
        
        contentView.addSubview(horizontalStackView)
        
        [commImageView, commLabel, UIView(), followButton].forEach { (view) in
            horizontalStackView.addArrangedSubview(view)
        }
        
        commImageView.image = UIImage(systemName: "camera.viewfinder")
        commLabel.text = "CommName123132"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        horizontalStackView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        commImageView.snp.makeConstraints { (make) in
            make.size.equalTo(35)
        }
    }
}
