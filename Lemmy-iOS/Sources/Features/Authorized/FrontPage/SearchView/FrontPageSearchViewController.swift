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
    
    private lazy var searchView = self.view as? FrontPageSearchView
    
    var searchQuery: String = "" {
        didSet {
            searchView?.configure(with: searchQuery)
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
        searchView?.fadeInIfNeeded()
    }
    
    func hideSearchIfNeeded() {
        searchView?.fadeOutIfNeeded()
    }
}

extension FrontPageSearchViewController: FrontPageSearchViewDelegate {
    func searchView(_ searchView: FrontPageSearchView, searchWith query: String, type: LMModels.Others.SearchType) {
        coordinator?.goToSearchResults(searchQuery: query, searchType: type)
    }
}
