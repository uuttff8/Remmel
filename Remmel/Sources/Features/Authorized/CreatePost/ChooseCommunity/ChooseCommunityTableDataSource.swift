//
//  ChooseCommunityTableDataSource.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 20.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMModels

protocol ChooseCommunityTableDataSourceDelegate: AnyObject {
    func tableDidSelect(community: RMModel.Views.CommunityView)
    func tableShowNotFound()
}

final class ChooseCommunityTableDataSource: NSObject {
    weak var delegate: ChooseCommunityTableDataSourceDelegate?
    
    var viewModels: [RMModel.Views.CommunityView]
    var filteredViewModels: [RMModel.Views.CommunityView] = []
    
    var shouldShowFiltered = false
    
    init(viewModels: [RMModel.Views.CommunityView] = []) {
        self.viewModels = viewModels
        super.init()
    }
    
    // MARK: - Public API
    
    func update(viewModel: RMModel.Views.CommunityView) {
        if let index = self.viewModels.firstIndex(where: { $0.community.id == viewModel.community.id }) {
            self.viewModels[index] = viewModel
        }
    }
    
    func getCurrentCellData(indexPath: IndexPath) -> RMModel.Views.CommunityView {
        if !filteredViewModels.isEmpty {
            return self.filteredViewModels[indexPath.row]
        } else {
            return self.viewModels[indexPath.row]
        }
    }
    
    func removeFilteredCommunities() {
        self.filteredViewModels.removeAll()
    }
}

extension ChooseCommunityTableDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowFiltered {
            if self.filteredViewModels.isEmpty {
                self.delegate?.tableShowNotFound()
            }

            return filteredViewModels.count
        }

        return viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = getCurrentCellData(indexPath: indexPath)

        let cell: CommunityMiniPreviewTableCell = tableView.cell(forRowAt: indexPath)
        cell.bind(with: .init(title: data.community.title, icon: data.community.icon))
        cell.updateConstraintsIfNeeded()
        return cell
    }
}

extension ChooseCommunityTableDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let community = getCurrentCellData(indexPath: indexPath)
        self.delegate?.tableDidSelect(community: community)

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
