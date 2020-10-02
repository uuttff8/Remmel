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
    
    weak var coordinator: FrontPageCoordinator?
    
    let model = FrontPageModel()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let navBar = LemmyFrontPageNavBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.systemBackground
        
        setupTableView()
        setupNavigationItem()
        
        model.loadPosts()
        model.dataLoaded = {
            self.tableView.reloadData()            
        }
        model.goToPostScreen = { (post) in
            self.coordinator?.goToPostScreen(post: post)
        }
        
        model.newDataLoaded = {
            // TODO: implement it
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
    
    private func setupNavigationItem() {
        // BUG: when navigation bar goes back, then constraits for nav bar gets broken
        navigationItem.titleView = navBar
        self.navBar.snp.makeConstraints { (make) in
            make.bottom.top.leading.trailing.equalToSuperview()
        }
    }
}
