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
    private var tableManager: SearchResultsTableDataSource
    
    private lazy var emptyStateLabel = UILabel().then {
        $0.text = "nodata-search".localized
        $0.textAlignment = .center
        $0.textColor = .tertiaryLabel
    }
    
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
        self.emptyStateLabel.isHidden = true
        
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
    
    func appendNew(data: [Any]) {
        let newIndexpaths = self.tableManager.getUpdatedIndexPaths(objects: data)
        tableView.performBatchUpdates {
            tableView.insertRows(at: newIndexpaths, with: .none)
        }
    }
    
    func displayNoData() {
        self.emptyStateLabel.isHidden = false
        
        self.addSubview(emptyStateLabel)
        self.emptyStateLabel.snp.makeConstraints {
            $0.center.equalTo(self.snp.center)
        }
    }
}

extension SearchResultsView: ProgrammaticallyViewProtocol {
    func setupView() {
        self.backgroundColor = .systemBackground
        self.emptyStateLabel.isHidden = true
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
