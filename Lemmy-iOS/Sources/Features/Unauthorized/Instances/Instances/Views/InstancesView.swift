//
//  InstancesView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 19.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class InstancesView: UIView {
    
    private let termsView = TermsOfUseView()
    
    private let tableView = LemmyTableView(style: .insetGrouped, separator: true)
    
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
    
    func updateTableViewData(dataSource: UITableViewDataSource & UITableViewDelegate) {
        _ = dataSource.tableView(self.tableView, numberOfRowsInSection: 0)
        //            self.emptyStateLabel.isHidden = numberOfRows != 0
        
        self.tableView.dataSource = dataSource
        self.tableView.delegate = dataSource
        self.tableView.reloadData()
    }
    
    func showLoadingView() {
        self.showActivityIndicatorView()
    }

    func hideLoadingView() {
        self.hideActivityIndicatorView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.layoutTableHeaderView()
    }
}

extension InstancesView: ProgrammaticallyViewProtocol {
    func setupView() {
        tableView.tableHeaderView = termsView
        tableView.tableHeaderView?.backgroundColor = .clear
    }
    
    func addSubviews() {
        self.addSubview(tableView)
    }
    
    func makeConstraints() {
        self.tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
