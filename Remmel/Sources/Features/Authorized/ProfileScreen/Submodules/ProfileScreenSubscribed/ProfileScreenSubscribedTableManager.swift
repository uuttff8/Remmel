//
//  ProfileScreenSubscribedDataSource.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 12.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMModels

class ProfileScreenSubscribedTableManager: NSObject {
    
    var viewModels: [RMModel.Views.CommunityFollowerView]

    init(viewModels: [RMModel.Views.CommunityFollowerView] = []) {
        self.viewModels = viewModels
        super.init()
    }
    
    func update(viewModel: RMModel.Views.CommunityFollowerView) {
        if let index = self.viewModels.firstIndex(where: { $0.community.id == viewModel.community.id }) {
            self.viewModels[index] = viewModel
        }
    }
}

extension ProfileScreenSubscribedTableManager: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.viewModels[indexPath.row]
        
        let cell: CommunityMiniPreviewTableCell = tableView.cell(forRowAt: indexPath)
        cell.bind(with: .init(title: data.community.title, icon: data.community.icon))
        cell.updateConstraintsIfNeeded()
        return cell
    }
}
