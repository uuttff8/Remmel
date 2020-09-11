//
//  FrontPageViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/11/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import SnapKit

class FrontPageViewController: UIViewController {
    
    let tableView = UITableView()
    let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        navigationItem.searchController = searchController
        navigationItem.title = "Lemmy"
        self.view.backgroundColor = UIColor.systemBackground
    }
}


extension FrontPageViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return FrontPageCells.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = FrontPageCells.allCases[section]
        switch section {
        case .header:
            return 1
        case .content:
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = FrontPageCells.allCases[indexPath.section]
        
        switch section {
        case .header:
            return UITableViewCell()
        case .content:
            let cell = UITableViewCell()
            cell.backgroundColor = .red
            return cell
        }
    }
}


private enum FrontPageCells: CaseIterable {
    case header
    case content
}
