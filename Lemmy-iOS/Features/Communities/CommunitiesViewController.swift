//
//  CommunitiesViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/14/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CommunitiesViewController: UIViewController {
    
    let model = CommunitiesModel()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        return tableView
    }()

    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.systemBackground
        
        setupTableView()
        model.loadCommunities()
        model.dataLoaded = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
    
    private func setupTableView() {
        tableView.delegate = model
        tableView.dataSource = model
        
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

}
