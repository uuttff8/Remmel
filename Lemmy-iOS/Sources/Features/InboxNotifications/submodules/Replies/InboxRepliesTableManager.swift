//
//  InboxRepliesTableManager.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol InboxRepliesTableManagerDelegate: AnyObject {
    func tableDidRequestPagination(_ tableManager: InboxRepliesTableManager)
}

final class InboxRepliesTableManager: NSObject {
    weak var delegate: InboxRepliesTableManagerDelegate?
    
    var viewModels: [LemmyModel.ReplyView]
    
    init(viewModels: [LemmyModel.ReplyView] = []) {
        self.viewModels = viewModels
        super.init()
    }
    
    // MARK: - Public API
    
    func update(viewModel: LemmyModel.ReplyView) {
        if let index = self.viewModels.firstIndex(where: { $0.id == viewModel.id }) {
            self.viewModels[index] = viewModel
        }
    }
    
    func appendNew(posts: [LemmyModel.ReplyView], completion: (_ indexPaths: [IndexPath]) -> Void) {
        let startIndex = viewModels.count - posts.count
        let endIndex = startIndex + posts.count
        
        let newIndexpaths = Array(startIndex ..< endIndex)
            .map { IndexPath(row: $0, section: 0) }
        
        completion(newIndexpaths)
    }
    
    func deleteAll() {
        viewModels = []
    }
}

// MARK: - UITableViewDataSource -
extension InboxRepliesTableManager: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ReplyMentionTableCell = tableView.cell(forRowAt: indexPath)
        cell.updateConstraintsIfNeeded()
        
        let viewModel = self.viewModels[indexPath.row]
        cell.configure(with: viewModel, level: 0)
        
        return cell
    }
}

extension InboxRepliesTableManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 5,
           tableView.numberOfSections == 1 {
            self.delegate?.tableDidRequestPagination(self)
        }
    }
}
