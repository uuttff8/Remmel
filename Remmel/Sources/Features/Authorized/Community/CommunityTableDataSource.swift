//
//  CommunityTableDataSource.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 15.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol CommunityScreenTableDataSourceDelegate: PostContentPreviewTableCellDelegate {
    func tableDidRequestPagination(_ tableDataSource: CommunityScreenTableDataSource)
}

final class CommunityScreenTableDataSource: NSObject {
    weak var delegate: CommunityScreenTableDataSourceDelegate?
    
    var viewModels: [LMModels.Views.PostView]
    
    init(viewModels: [LMModels.Views.PostView] = []) {
        self.viewModels = viewModels
        super.init()
    }
    
    // MARK: - Public API
    
    func update(viewModel: LMModels.Views.PostView) {
        if let index = self.viewModels.firstIndex(where: { $0.id == viewModel.id }) {
            self.viewModels[index] = viewModel
        }
    }
    
    func appendNew(posts: [LMModels.Views.PostView], completion: (_ indexPaths: [IndexPath]) -> Void) {
        let startIndex = viewModels.count - posts.count
        let endIndex = startIndex + posts.count
        
        let newIndexpaths =
            Array(startIndex ..< endIndex)
            .map { index in
                IndexPath(row: index, section: 0)
            }
        
        completion(newIndexpaths)
    }
}

// MARK: - UITableViewDataSource -
extension CommunityScreenTableDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PostContentPreviewTableCell = tableView.cell(forRowAt: indexPath)
        cell.updateConstraintsIfNeeded()
        
        let viewModel = self.viewModels[indexPath.row]
        cell.bind(with: viewModel, isInsideCommunity: true)
        cell.postContentView.delegate = delegate
        
        return cell
    }
}

extension CommunityScreenTableDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 5,
           tableView.numberOfSections == 1 {
            self.delegate?.tableDidRequestPagination(self)
        }
    }
}
