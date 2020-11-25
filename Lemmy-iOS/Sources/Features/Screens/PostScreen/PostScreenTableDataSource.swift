//
//  PostScreenTableDataSource.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 13.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class PostScreenTableDataSource: NSObject {
    var viewModels: [LemmyComment]
    
    init(viewModels: [LemmyComment] = []) {
        self.viewModels = viewModels
        super.init()
    }
    
    // MARK: - Public API
    func update(viewModel: LemmyComment) {
        if let index = self.viewModels.firstIndex(where: { $0.id == viewModel.id }) {
            self.viewModels[index] = viewModel
        }
    }
}

extension PostScreenTableDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CommentTreeTableCell = tableView.cell(forRowAt: indexPath)
        cell.updateConstraintsIfNeeded()

        let viewModel = self.viewModels[indexPath.row]
//        cell.bind(with: viewModel)

        return cell
    }
}
