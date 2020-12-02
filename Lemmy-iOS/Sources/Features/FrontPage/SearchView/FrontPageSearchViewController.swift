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
    
    open var searchQuery: String = "" {
        didSet {
            searchView.configure(with: searchQuery)
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = FrontPageSearchView()
        view.delegate = self
        self.view = view
    }
    
    func showSearchIfNeeded() {
        self.searchView.fadeInIfNeeded()
    }
    
    func hideSearchIfNeeded() {
        self.searchView.fadeOutIfNeeded()
    }
}

extension FrontPageSearchViewController: FrontPageSearchViewDelegate {
    func searchView(_ searchView: FrontPageSearchView, searchWith query: String, type: LemmySearchType) {
        
        switch type {
        case .comments:
            print("search for comments in \(#file) \(#line)")
        case .posts:
            print("search for posts in \(#file) \(#line)")
        case .communities:
            print("search for communities in \(#file) \(#line)")
        case .users:
            print("search for users in \(#file) \(#line)")
        }
    }
}
