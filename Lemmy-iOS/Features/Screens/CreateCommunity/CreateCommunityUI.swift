//
//  CreateCommunityUI.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 28.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CreateCommunityUI: UIView {
    
    // MARK: - Properties
    let tableView = LemmyTableView(style: .plain)
    let model: CreateCommunityModel
    
    // MARK: - Init
    init(model: CreateCommunityModel) {
        self.model = model
        super.init(frame: .zero)
        
        self.setupTableView()
        self.hideKeyboardWhenTappedAround()
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
    
    // MARK: - Private API
    private func setupTableView() {
        self.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension CreateCommunityUI: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
