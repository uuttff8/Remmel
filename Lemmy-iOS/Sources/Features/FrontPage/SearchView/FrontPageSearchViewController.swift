//
//  FrontPageSearchViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 14.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class FrontPageSearchViewController: UIViewController {
    
    weak var coordinator: FrontPageCoordinator?
    
    private lazy var searchView = self.view as! FrontPageSearchView
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = FrontPageSearchView()
    }
    
    func showSearchIfNeeded() {
        self.searchView.fadeInIfNeeded()
    }
    
    func hideSearchIfNeeded() {
        self.searchView.fadeOutIfNeeded()
    }
}
