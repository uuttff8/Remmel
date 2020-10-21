//
//  CreatePostUI.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 20.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CreatePostScreenUI: UIView {
    var goToChoosingCommunity: (() -> Void)?
    
    enum CellType: CaseIterable {
        case community, url, content
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
        
        tableView.register(CreatePostCommunityCell.self,
                           forCellReuseIdentifier: String(describing: CreatePostCommunityCell.self))
        tableView.register(CreatePostUrlCell.self,
                           forCellReuseIdentifier: String(describing: CreatePostUrlCell.self))
        
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CreatePostCommunityCell.self))
            else { return UITableViewCell() }
            
            return cell
        case .content:
            return UITableViewCell()
        case .url:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CreatePostUrlCell.self.self))
            else { return UITableViewCell() }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = CellType.allCases[indexPath.row]
        
        switch cellType {
        case .community:
            goToChoosingCommunity?()
        default: break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
