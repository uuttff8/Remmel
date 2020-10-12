//
//  PostsFrontPageViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class PostsFrontPageViewController: UIViewController {
    let model = PostsFrontPageModel()
    let tableView = LemmyUITableView(style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = model
        tableView.dataSource = model
        
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        
        model.loadPosts()
        model.dataLoaded = { [self] in
            tableView.reloadData()
        }
    }
}
