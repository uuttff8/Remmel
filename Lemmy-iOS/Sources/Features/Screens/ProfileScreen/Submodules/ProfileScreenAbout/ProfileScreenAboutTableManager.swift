//
//  ProfileScreenAboutDataSource.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 12.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class ProfileScreenAboutTableManager: NSObject {
        
    var viewModels: [LMModels.Views.CommunityFollowerView]

    init(viewModels: [LMModels.Views.CommunityFollowerView] = []) {
        self.viewModels = viewModels
        super.init()
    }
    
    func update(viewModel: LMModels.Views.CommunityFollowerView) {
        if let index = self.viewModels.firstIndex(where: { $0.community.id == viewModel.community.id }) {
            self.viewModels[index] = viewModel
        }
    }
}

extension ProfileScreenAboutTableManager: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.cell(forRowAt: indexPath)
        cell.updateConstraintsIfNeeded()

        let viewModel = self.viewModels[indexPath.row]
        cell.textLabel?.text = viewModel.community.name

        return cell
    }
}
