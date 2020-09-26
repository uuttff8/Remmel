//
//  LemmyFrontPageNavBar.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/26/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class LemmyFrontPageNavBar: UIView {
    let searchBar = LemmySearchBar()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind() {
        self.addSubview(searchBar)
        self.searchBar.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(60)
        }
    }
}
