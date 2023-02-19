//
//  InboxMessagesTableManager.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMModels

protocol InboxMessagesTableManagerDelegate: MessageCellViewDelegate {
    func tableDidRequestPagination(_ tableManager: InboxMessagesTableManager)
}

final class InboxMessagesTableManager: NSObject {
    weak var delegate: InboxMessagesTableManagerDelegate?
    
    var viewModels: [RMModel.Views.PrivateMessageView]
    
    init(viewModels: [RMModel.Views.PrivateMessageView] = []) {
        self.viewModels = viewModels
        super.init()
    }
    
    // MARK: - Public API
    
    func update(viewModel: RMModel.Views.PrivateMessageView) {
        if let index = self.viewModels.firstIndex(where: { $0.privateMessage.id == viewModel.privateMessage.id }) {
            self.viewModels[index] = viewModel
        }
    }
    
    func appendNew(posts: [RMModel.Views.PrivateMessageView], completion: (_ indexPaths: [IndexPath]) -> Void) {
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
extension InboxMessagesTableManager: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MessageTableCell = tableView.cell(forRowAt: indexPath)
        cell.updateConstraintsIfNeeded()
        
        let viewModel = self.viewModels[indexPath.row]
        cell.configure(viewModel: viewModel)
        cell.delegate = delegate
        
        return cell
    }
}

extension InboxMessagesTableManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 5,
           tableView.numberOfSections == 1 {
            self.delegate?.tableDidRequestPagination(self)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
