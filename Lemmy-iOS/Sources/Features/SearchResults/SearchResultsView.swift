//
//  SearchResultsView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 03.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class SearchResultsView: UIView {
    
    private lazy var tableView = LemmyTableView(style: .plain, separator: false).then {
        $0.registerClass(PostContentTableCell.self)
        $0.registerClass(CommentContentTableCell.self)
        $0.registerClass(CommunityPreviewTableCell.self)
        
        $0.delegate = tableManager
        $0.dataSource = tableManager
    }
    private var tableManager: (UITableViewDataSource & UITableViewDelegate)
    
    init(tableManager: (UITableViewDataSource & UITableViewDelegate)) {
        self.tableManager = tableManager
        super.init(frame: .zero)
        
        setupView()
        addSubviews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTableViewData(delegate: UITableViewDelegate & UITableViewDataSource) {
        self.tableManager = delegate

        self.tableView.dataSource = self.tableManager
        self.tableView.reloadData()
    }
}

extension SearchResultsView: ProgrammaticallyViewProtocol {
    func setupView() {
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
