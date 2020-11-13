//
//  LoadingTableViewCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 07.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {
    init() {
        super.init(style: .default, reuseIdentifier: String(describing: Self.self))
        
        self.showLoading(style: .large, color: .gray)
        
        self.contentView.snp.makeConstraints {
            $0.height.equalTo(200)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
