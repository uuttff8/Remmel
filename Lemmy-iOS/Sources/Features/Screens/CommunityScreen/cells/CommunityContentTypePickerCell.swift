//
//  CommunityContentTypePickerCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 03.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CommunityContentTypePickerCell: UITableViewCell {
    let customView = LemmyImageTextTypePicker(cases: LemmySortType.allCases,
                                              firstPicked: .active,
                                              image: Config.Image.sortType)
    
    init() {
        super.init(style: .default, reuseIdentifier: String(describing: Self.self))
        
        self.contentView.addSubview(customView)
        
        self.snp.makeConstraints {
            $0.edges.equalTo(customView)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
