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
    let viewModels: [AnyObject]
    let searchType: LemmySearchType
    
    let delegateImpl: SearchResultsViewController
    
    init(viewModels: [AnyObject] = [], searchType: LemmySearchType, delegateImpl: SearchResultsViewController) {
        self.viewModels = viewModels
        self.searchType = searchType
        self.delegateImpl = delegateImpl
        super.init()
    }
    
    func appendNew(objects: [AnyObject]) -> [IndexPath] {
        let startIndex = viewModels.count - objects.count
        let endIndex = startIndex + objects.count
        
        let newIndexPaths =
            Array(startIndex ..< endIndex)
            .map { (index) in
                IndexPath(row: index, section: 0)
            }
        
        return newIndexPaths
    }
}

extension SearchResultsTableDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
