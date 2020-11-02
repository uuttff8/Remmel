//
//  CommunityScreenUI.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 01.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

class CommunityScreenUI: UIView {
    
    var presentParsedVc: ((String) -> Void)?
    
    enum TableRows: CaseIterable {
        case header, contentTypePicker, content
    }
    
    let tableView = LemmyTableView(style: .plain, separator: false)
    let model: CommunityScreenModel
    var cancellable = Set<AnyCancellable>()
    
    init(model: CommunityScreenModel) {
        self.model = model
        super.init(frame: .zero)
        
        self.addSubview(tableView)
        setupTableView()
        
        model.communitySubject
            .receive(on: RunLoop.main)
            .sink { (community) in
            if community != nil {
                self.tableView.reloadData()
            }
        }.store(in: &cancellable)
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
            guard let communityInfo = model.communitySubject.value else { return UITableViewCell() }
            
            let cell = CommunityHeaderCell()
            cell.presentParsedVc = { self.presentParsedVc?($0) }
            cell.bind(with: communityInfo)
            return cell
            
        default: return UITableViewCell()
        }
    }
}
