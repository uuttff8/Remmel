//
//  SearchResultsAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 03.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class SearchResultsAssembly: Assembly {
    private let searchQuery: String
    private let searchType: LemmySearchSortType
    
    init(searchQuery: String, type: LemmySearchSortType) {
        self.searchQuery = searchQuery
        self.searchType = type
    }
    
    func makeModule() -> SearchResultsViewController {
        let viewModel = SearchResultsViewModel(searchQuery: searchQuery, searchType: searchType)
        let vc = SearchResultsViewController(viewModel: viewModel)
        viewModel.viewController = vc
        
        return vc
    }
}
