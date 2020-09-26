//
//  LemmySeatchBarView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/16/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class LemmySearchBarView: UIView {
    
    let searchView = LemmySearchBar()

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind() {
        self.addSubview(searchView)
        
        searchView.snp.makeConstraints { (make) in
            make.top.bottom.trailing.leading.equalToSuperview()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: UIView.noIntrinsicMetric)
    }
}

class LemmySearchBar: UISearchBar, UISearchBarDelegate {
    init() {
        super.init(frame: .zero)
        
        self.placeholder = "Search"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
