//
//  CommunitiesPreviewDataSource.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 16.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol CommunitiesPreviewTableDataSourceDelegate: AnyObject {
    func tableDidSelect(community: LemmyModel.CommunityView)
}

class CommunitiesPreviewDataSource: NSObject {
    weak var delegate: CommunitiesPreviewTableDataSourceDelegate?
    
    var viewModels: [LemmyModel.CommunityView]
    
    init(viewModels: [LemmyModel.CommunityView] = []) {
        self.viewModels = viewModels
        super.init()
    }
}

extension CommunitiesPreviewDataSource: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CommunityPreviewTableCell = tableView.cell(forRowAt: indexPath)
        cell.updateConstraintsIfNeeded()
        
        let viewModel = self.viewModels[indexPath.row]
        cell.bind(community: viewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = self.viewModels[indexPath.row]
        self.delegate?.tableDidSelect(community: viewModel)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
