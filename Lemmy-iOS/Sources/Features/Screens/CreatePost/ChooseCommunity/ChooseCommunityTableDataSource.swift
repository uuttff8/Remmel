//
//  ChooseCommunityTableDataSource.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 20.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol ChooseCommunityTableDataSourceDelegate: AnyObject {
    func tableDidSelect(community: LemmyModel.CommunityView)
    func tableShowNotFound()
}

final class ChooseCommunityTableDataSource: NSObject {
    weak var delegate: ChooseCommunityTableDataSourceDelegate?
    
    var viewModels: [LemmyModel.CommunityView]
    var filteredViewModels: [LemmyModel.CommunityView] = []
    
    var shouldShowFiltered = false
    
    init(viewModels: [LemmyModel.CommunityView] = []) {
        self.viewModels = viewModels
        super.init()
    }
    
    // MARK: - Public API
    
    func update(viewModel: LemmyModel.CommunityView) {
        if let index = self.viewModels.firstIndex(where: { $0.id == viewModel.id }) {
            self.viewModels[index] = viewModel
        }
    }
    
    func getCurrentCellData(indexPath: IndexPath) -> LemmyModel.CommunityView {
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
//                self.tableView.setEmptyMessage("Not found")
                self.delegate?.tableShowNotFound()
            }

            return filteredViewModels.count
        }

        return viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = getCurrentCellData(indexPath: indexPath)

        let cell = ChooseCommunityCell()
        cell.bind(with: .init(title: data.title, icon: data.icon))
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
