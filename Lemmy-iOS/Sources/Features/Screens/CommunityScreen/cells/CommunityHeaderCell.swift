//
//  CommunityHeaderCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 04.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CommunityHeaderCell: UITableViewCell {
    
    let mainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    let horizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .leading
    }
        
    let communityHeaderView = CommunityHeaderView()
    let contentTypeView = LemmyImageTextTypePicker(cases: LemmySortType.self,
                                                   firstPicked: LemmySortType.active,
                                                   image: Config.Image.sortType)
        
    init() {
        super.init(style: .default, reuseIdentifier: String(describing: Self.self))
        
        selectionStyle = .none
        self.backgroundColor = .systemBackground
        
        contentView.addSubview(mainStackView)
    }
    
    func bindData(community: LemmyModel.CommunityView) {
        communityHeaderView.bind(with: community)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
