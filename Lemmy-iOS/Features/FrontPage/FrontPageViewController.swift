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
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        return tableView
    }()
    
    let searchController: UISearchController = {
        let search = UISearchController()
        search.hidesNavigationBarDuringPresentation = false
        search.obscuresBackgroundDuringPresentation = true
        return search
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
        
        tableView.keyboardDismissMode = .onDrag
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        navigationItem.titleView = searchController.searchBar
        navigationItem.titleView?.frame.size.width = UIScreen.main.bounds.width
        self.view.backgroundColor = UIColor.systemBackground
        
        
        let parameters = LemmyApiStructs.Post.GetPostsRequest(type_: "All",
                                                              sort: "Active",
                                                              page: 1,
                                                              limit: 20,
                                                              communityId: nil,
                                                              communityName: nil,
                                                              auth: nil)
        
        ApiManager.shared.requestsManager.getPosts(
            parameters: parameters,
            completion: { (dec: Result<LemmyApiStructs.Post.GetPostsResponse, Error>) in
                switch dec {
                case .success(let sss):
                    print(sss)
                case .failure(let error):
                    print(error)
                }
        })
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
            return FrontPageHeaderCell()
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
