//
//  PostsTableDataSource.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 16.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol PostsTableDataSourceDelegate: AnyObject {
    func postsDataSource(didSelect post: LemmyModel.PostView)
}

class PostsTableDataSource: NSObject {
    weak var delegate: PostsTableDataSourceDelegate?
    
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

extension PostsTableDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = viewModels[indexPath.row]
        self.delegate?.postsDataSource(didSelect: post)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension PostsTableDataSource: UITableViewDataSource {
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
