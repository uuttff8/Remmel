//
//  LemmySeatchBarView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/16/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class LemmySearchBarView: UIView {
    
    let searchController: UISearchController = {
        let search = UISearchController()
        search.hidesNavigationBarDuringPresentation = false
        search.obscuresBackgroundDuringPresentation = true
        return search
    }()

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind() {
        self.addSubview(searchController.searchBar)
        
        searchController.searchBar.snp.makeConstraints { (make) in
            make.top.bottom.trailing.leading.equalToSuperview()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: UIView.noIntrinsicMetric)
    }
}

private class LemmySearchBar: UISearchBar, UISearchBarDelegate {
    
}
