//
//  CreatePostUI.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 20.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CreatePostScreenUI: UIView {

    // MARK: Cell type
    enum CellType: CaseIterable {
        case community, url, content
    }

    // MARK: - Properties
    var goToChoosingCommunity: (() -> Void)?
    var onPickImage: (() -> Void)?
    var onPickedImage: ((UIImage) -> Void)?

    let tableView = LemmyTableView(style: .plain)
    let model: CreatePostScreenModel

    let communityCell = CreatePostCommunityCell()
    lazy var contentCell = CreatePostContentCell(backView: self)
    let urlCell = CreatePostUrlCell()

    // MARK: - Init
    init(model: CreatePostScreenModel) {
        self.model = model
        super.init(frame: .zero)

        setupTableView()
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

// MARK: - Data source actions -
extension CreatePostScreenUI: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        CellType.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = CellType.allCases[indexPath.row]

        switch cellType {
        case .community:
            let cell = communityCell
            model.communitySelectedCompletion = { community in
                cell.bind(with: community)
            }

            return cell
        case .content:
            return contentCell
        case .url:
            urlCell.onPickImage = {
                self.onPickImage?()
            }
            self.onPickedImage = { image in
                self.urlCell.onPickedImage?(image)
            }

            return urlCell
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
