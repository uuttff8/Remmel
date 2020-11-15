//
//  CommunityTableDataSource.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 15.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class CommunityScreenTableDataSource: NSObject {
    var viewModels: [LemmyModel.PostView]

    init(viewModels: [LemmyModel.PostView] = []) {
        self.viewModels = viewModels
        super.init()
    }

    // MARK: - Public API

    func update(viewModel: LemmyModel.PostView) {
        if let index = self.viewModels.firstIndex(where: { $0.id == viewModel.id }) {
            self.viewModels[index] = viewModel
        }
    }
}

// MARK: - CourseInfoTabReviewsTableViewDataSource: UITableViewDataSource -

extension CommunityScreenTableDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PostContentTableCell = tableView.cell(forRowAt: indexPath)
        cell.updateConstraintsIfNeeded()

        let viewModel = self.viewModels[indexPath.row]
        cell.bind(with: viewModel, config: .insideComminity)

        return cell
    }
}
