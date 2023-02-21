//
//  InstancesTableDataSource.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 19.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMFoundation
import RMServices

protocol InstancesTableDataSourceDelegate: AnyObject {
    func tableDidRequestDelete(_ instance: Instance)
    func tableDidRequestAddAccountsModule(_ instance: Instance)
}

final class InstancesTableDataSource: NSObject {
    
    weak var delegate: InstancesTableDataSourceDelegate?
    
    var viewModels: [Instance]
    
    init(viewModels: [Instance] = []) {
        self.viewModels = viewModels
        super.init()
    }
}

extension InstancesTableDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.accessoryType = .disclosureIndicator
        
        let instance = viewModels[indexPath.row]
        cell.textLabel?.text = instance.label
        
        return cell
    }
}

extension InstancesTableDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let instance = viewModels[indexPath.row]
        delegate?.tableDidRequestAddAccountsModule(instance)
        debugPrint("Instance choosed: \(instance)")
      
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        
        let instance = viewModels[indexPath.row]
        
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Delete",
            handler: { _, _, completion in
                
                if let index = self.viewModels.firstIndex(where: { $0.label == instance.label }) {
                    self.viewModels.remove(at: index)
                    
                    self.delegate?.tableDidRequestDelete(instance)
                    
                    completion(true)
                    tableView.performBatchUpdates {
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                }
            })
        
        return UISwipeActionsConfiguration(
            actions: [
                deleteAction
            ]
        )
    }
}
