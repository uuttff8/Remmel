//
//  CreatePostUI.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 20.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CreatePostScreenUI: UIView {
    var goToChoosingCommunity: (() -> Void)?
    var onPickImage: (() -> Void)?
    var onPickedImage: ((UIImage) -> Void)?
    
    enum CellType: CaseIterable {
        case community, url, content
    }
    
    // MARK: - Properties
    let tableView = LemmyTableView(style: .plain)
    let model: CreatePostScreenModel
    
    // MARK: - Init
    init(model: CreatePostScreenModel) {
        self.model = model
        super.init(frame: .zero)
        
        setupTableView()
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

// MARK: - Data source actions -
extension CreatePostScreenUI: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        CellType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = CellType.allCases[indexPath.row]
        
        switch cellType {
        case .community:
            let cell = CreatePostCommunityCell()
            model.communitySelected = { community in
                cell.bind(with: community)
            }
            return cell
        case .content:
            let cell = CreatePostContentCell()
            return cell
        case .url:
            let cell = CreatePostUrlCell()
            cell.onPickImage = {
                self.onPickImage?()
            }
            self.onPickedImage = { image in
                cell.onPickedImage?(image)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = CellType.allCases[indexPath.row]
        
        switch cellType {
        case .community:
            goToChoosingCommunity?()
        default: break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
