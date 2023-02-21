//
//  ProfileScreenCommentsTableDataSource.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 11.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMModels

protocol ProfileScreenCommentsTableDataSourceDelegate: CommentContentTableCellDelegate {
    func tableDidRequestPagination(_ tableDataSource: ProfileScreenCommentsTableDataSource)
}

class ProfileScreenCommentsTableDataSource: NSObject {
    var viewModels: [RMModels.Views.CommentView]

    weak var delegate: ProfileScreenCommentsTableDataSourceDelegate?
    
    init(viewModels: [RMModels.Views.CommentView] = []) {
        self.viewModels = viewModels
        super.init()
    }
    
    func update(viewModel: RMModels.Views.CommentView) {
        if let index = self.viewModels.firstIndex(where: { $0.id == viewModel.id }) {
            self.viewModels[index] = viewModel
        }
    }
    
    func appendNew(comments: [RMModels.Views.CommentView], completion: (_ indexPaths: [IndexPath]) -> Void) {
        let startIndex = viewModels.count - comments.count
        let endIndex = startIndex + comments.count
        
        let newIndexpaths =
            Array(startIndex ..< endIndex)
            .map { index in
                IndexPath(row: index, section: 0)
            }
        
        completion(newIndexpaths)
    }
    
    func deleteAll() {
        viewModels = []
    }
}

extension ProfileScreenCommentsTableDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CommentContentTableCell = tableView.cell(forRowAt: indexPath)
        cell.updateConstraintsIfNeeded()

        let viewModel = self.viewModels[indexPath.row]
        cell.commentContentView.delegate = delegate
        cell.bind(with: viewModel, level: 0)

        return cell
    }
}

extension ProfileScreenCommentsTableDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 5,
           tableView.numberOfSections == 1 {
            self.delegate?.tableDidRequestPagination(self)
        }
    }
}
