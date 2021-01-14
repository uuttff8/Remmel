//
//  SearchResultsView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 03.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class SearchResultsView: UIView {
    
    private var tableView: LemmyTableView!
    private var tableManager: (UITableViewDataSource & UITableViewDelegate)
    
    init(tableManager: (SearchResultsTableDataSource)) {
        self.tableManager = tableManager
        super.init(frame: .zero)
        
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTableViewData(delegate: SearchResultsTableDataSource) {
        self.tableManager = delegate
        
        let type: UITableView.Style
        
        if case .users = delegate.viewModels {
            type = .insetGrouped
        } else {
            type = .plain
        }
        
        self.tableView = LemmyTableView(style: type, separator: false).then {
            $0.registerClass(PostContentPreviewTableCell.self)
            $0.registerClass(CommentContentTableCell.self)
            $0.registerClass(CommunityPreviewTableCell.self)
            $0.registerClass(UserPreviewCell.self)
            
            $0.delegate = tableManager
            $0.dataSource = tableManager
        }
        
        setupView()
        addSubviews()
        makeConstraints()
        
        self.tableView.dataSource = self.tableManager
        self.tableView.reloadData()
    }
}

extension SearchResultsView: ProgrammaticallyViewProtocol {
    func setupView() {
        self.backgroundColor = .systemBackground
    }
    
    func addSubviews() {
        self.addSubview(self.tableView)
    }
    
    func makeConstraints() {
        
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
