//
//  AccountsTableDataSource.swift
//  Lemmy-iOS
//
//  Created by Komolbek Ibragimov on 25/12/2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol AccountsTableDataSourceDelegate: AnyObject {
    func tableDidRequestDelete(_ instance: Account)
    func tableDidRequestAddAccountsModule(_ instance: Account)
}

final class AccountsTableDataSource: NSObject {
    
    weak var delegate: AccountsTableDataSourceDelegate?
    
    var viewModels: [Account]
    
    init(viewModels: [Account] = []) {
        self.viewModels = viewModels
        super.init()
    }
}

extension AccountsTableDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.accessoryType = .disclosureIndicator
        
        let account = viewModels[indexPath.row]
        cell.textLabel?.text = account.login
        
        return cell
    }
}

extension AccountsTableDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let account = viewModels[indexPath.row]
        print(account)
        delegate?.tableDidRequestAddAccountsModule(account)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        
        let account = viewModels[indexPath.row]
        
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Delete",
            handler: { (_, _, completion) in
                
                if let index = self.viewModels.firstIndex(where: { $0.login == account.login }) {
                    self.viewModels.remove(at: index)
                    
                    self.delegate?.tableDidRequestDelete(account)
                    
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
