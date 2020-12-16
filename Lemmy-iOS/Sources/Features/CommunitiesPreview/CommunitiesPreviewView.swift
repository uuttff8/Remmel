//
//  CommunitiesPreviewView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 16.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CommunitiesPreviewView: UIView {
    
    private lazy var tableView = LemmyTableView(style: .plain, separator: false).then {
        $0.registerClass(CommunityPreviewTableCell.self)
    }
    
    init() {
        super.init(frame: .zero)
        
        setupView()
        addSubviews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showLoadingView() {
        tableView.showActivityIndicator()
    }
    
    func hideLoadingView() {
        tableView.hideActivityIndicator()
    }
    
    func updateTableViewData(dataSource: (UITableViewDataSource & UITableViewDelegate)) {
        _ = dataSource.tableView(self.tableView, numberOfRowsInSection: 0)
        //            self.emptyStateLabel.isHidden = numberOfRows != 0
        
        self.tableView.dataSource = dataSource
        self.tableView.delegate = dataSource
        self.tableView.reloadData()
    }
}

extension CommunitiesPreviewView: ProgrammaticallyViewProtocol {
    func addSubviews() {
        self.addSubview(tableView)
    }
    
    func makeConstraints() {
        self.tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
