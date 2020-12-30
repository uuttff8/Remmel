//
//  AccountsTableDataSource.swift
//  Lemmy-iOS
//
//  Created by Komolbek Ibragimov on 25/12/2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol AccountsTableDataSourceDelegate: AnyObject {
    func tableDidRequestDelete(_ account: Account)
    func tableDidSelect(_ account: Account)
    func tableDidSelectGuestPreview()
}

final class AccountsTableDataSource: NSObject {
    
    enum AccountType: Int {
        case guest = 0
        case users = 1
    }
    
    weak var delegate: AccountsTableDataSourceDelegate?
    
    var viewModels: [Account]
    
    init(viewModels: [Account] = []) {
        self.viewModels = viewModels
        super.init()
    }
    
    private func getAccount(for indexPath: IndexPath) -> Account {
        viewModels[indexPath.row - 1]
    }
}

extension AccountsTableDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count + 1 // 1 is a guest
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: UITableViewCell = tableView.cell(forRowAt: indexPath)
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = "Enter as guest"
            return cell
        }
        
        let cell = UITableViewCell()
        cell.accessoryType = .disclosureIndicator
        
        let account = getAccount(for: indexPath)
        cell.textLabel?.text = account.login
        
        return cell
    }
}

extension AccountsTableDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            delegate?.tableDidSelectGuestPreview()
            return
        }
        
        let account = getAccount(for: indexPath)
        print(account)
        delegate?.tableDidSelect(account)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        
        if indexPath.row == 0 {
            return nil
        }
        
        let account = getAccount(for: indexPath)
        
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
