//
//  LemmySeatchBarView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/16/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class LemmySearchBarController: UISearchController {

    private lazy var customSearchBar = LemmySearchBar()

    override var searchBar: UISearchBar {
        customSearchBar
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        self.hidesNavigationBarDuringPresentation = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
