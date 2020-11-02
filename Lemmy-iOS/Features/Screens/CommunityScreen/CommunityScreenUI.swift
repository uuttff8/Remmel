//
//  CommunityScreenUI.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 01.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CommunityScreenUI: UIView {
    
    enum TableRows: CaseIterable {
        case header, contentTypePicker, content
    }
    
    let tableView = LemmyTableView(style: .plain, separator: false)
    
    init() {
        super.init(frame: .zero)
        
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension CommunityScreenUI: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Self.TableRows.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = Self.TableRows.allCases[indexPath.row]
        
        switch type {
        case .header:
            let cell = CommunityHeaderCell()
            return cell
            
        default: return UITableViewCell()
        }
    }
}
