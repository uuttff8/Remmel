//
//  SearchResultsTableDataSource.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 03.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol SearchResultsTableDataSourceDelegate: AnyObject {
    func tableDidRequestPagination(_ tableDataSource: SearchResultsTableDataSource)
    func postDidSelect(post: LemmyModel.PostView)
    // other functions
}

final class SearchResultsTableDataSource: NSObject {
    var viewModels: SearchResults.Results
    
    let delegateImpl: SearchResultsViewController
    
    init(viewModels: SearchResults.Results = .posts([]), delegateImpl: SearchResultsViewController) {
        self.viewModels = viewModels
        self.delegateImpl = delegateImpl
        super.init()
    }
    
    func appendNew(objects: [AnyObject] = []) -> [IndexPath] {
        let startIndex = countViewModels() - objects.count
        let endIndex = startIndex + objects.count
        
        let newIndexPaths = Array(startIndex ..< endIndex)
            .map { IndexPath(row: $0, section: 0) }
        
        return newIndexPaths
    }
    
    private func countViewModels() -> Int {
        switch viewModels {
        case let .comments(data): return data.count
        case let .posts(data): return data.count
        case let .communities(data): return data.count
        case let .users(data): return data.count
        }
    }
}

extension SearchResultsTableDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.countViewModels()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension SearchResultsTableDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
