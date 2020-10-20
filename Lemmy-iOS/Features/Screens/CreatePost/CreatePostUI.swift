//
//  CreatePostUI.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 20.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CreatePostScreenUI: UIView {
    enum CellType: CaseIterable {
        case community, content
    }
    
    // MARK: - Properties
    let tableView = LemmyTableView(style: .plain)
    private let model = CreatePostScreenModel()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        setupTableView()
        model.loadCommunities()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: - Overrided
    override func layoutSubviews() {
        super.layoutSubviews()
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func setupTableView() {
        self.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - Data source actions -
extension CreatePostScreenUI: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        CellType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = CellType.allCases[indexPath.row]
        
        switch cellType {
        case .community:
            return UITableViewCell()
        case .content:
            return UITableViewCell()
        }
    }
}
