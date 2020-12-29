//
//  AccountsView.swift
//  Lemmy-iOS
//
//  Created by Komolbek Ibragimov on 24/12/2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class AccountsView: UIView {
    
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
}

extension AccountsView: ProgrammaticallyViewProtocol {
    func setupView() { }
    
    func addSubviews() {
        self.addSubview(tableView)
    }
    
    func makeConstraints() {
        self.tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
