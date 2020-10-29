//
//  CreateCommunityUI.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 28.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

class CreateCommunityUI: UIView {
    
    // MARK: Cell type
    enum CellType: CaseIterable {
        case name, displayName, category, sidebarAndNsfw
    }
    
    // MARK: - Properties
    let tableView = LemmyTableView(style: .grouped)
    let model: CreateCommunityModel
    
    var cancellable = Set<AnyCancellable>()
    
    // MARK: - Init
    init(model: CreateCommunityModel) {
        self.model = model
        super.init(frame: .zero)
        
        model.categories
            .receive(on: RunLoop.main)
            .sink { (categories) in
                self.tableView.reloadData()
            }
            .store(in: &cancellable)
        
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = CellType.allCases[indexPath.row]
        
        switch type {
        case .name: return CreateCommunityNameCell()
        case .displayName: return CreateCommunityDisplayNameCell()
        case .category: break
        case .sidebarAndNsfw: break
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let type = CellType.allCases[section]
        
        switch type {
        case .name:
            return "Name – used as the identifier for the community, cannot be changed."
        case .displayName:
            return "Display name — shown as the title on the community's page, can be changed."
        default:
            return nil
        }
    }
}
