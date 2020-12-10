//
//  ProfileScreenCommentsTableDataSource.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 11.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol ProfileScreenCommentsTableDataSourceDelegate: CommentContentTableCellDelegate { }

class ProfileScreenCommentsTableDataSource: NSObject {
    var viewModels: [LemmyModel.CommentView]

    weak var delegate: ProfileScreenCommentsTableDataSourceDelegate?
    
    init(viewModels: [LemmyModel.CommentView] = []) {
        self.viewModels = viewModels
        super.init()
    }
    
    func update(viewModel: LemmyModel.CommentView) {
        if let index = self.viewModels.firstIndex(where: { $0.id == viewModel.id }) {
            self.viewModels[index] = viewModel
        }
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
