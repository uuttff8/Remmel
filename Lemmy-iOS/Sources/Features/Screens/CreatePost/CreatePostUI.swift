//
//  CreatePostUI.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 20.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol CreatePostViewDelegate: SettingsTableViewDelegate { }

class CreatePostScreenUI: UIView {

    // MARK: Cell type
    enum Section: Int, CaseIterable {
        case community, url, title, body, nsfw
        
        var headerTitle: String? {
            switch self {
            case .community: return "Choose community"
            default: return nil
            }
        }
        
        var footerTitle: String? {
            switch self {
            case .community: return nil
            case .url: return "url for your post"
            case .title: return "Title for your post. Required."
            case .body: return "Body for your post. Optional"
            case .nsfw: return nil
            }
        }
    }

    // MARK: - Properties
    var goToChoosingCommunity: (() -> Void)?
    var onPickImage: (() -> Void)?
    var onPickedImage: ((UIImage) -> Void)?

    let tableView = LemmyTableView(style: .grouped)
    let model: CreatePostScreenModel

    let communityCell = CreatePostCommunityCell()
    lazy var contentCell = CreatePostContentCell(backView: self)

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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = Section.allCases[indexPath.section]

        switch section {
        case .community:
            let cell = communityCell
            model.communitySelectedCompletion = { community in
                cell.bind(with: community)
            }

            return cell
        case .url:
            let urlCell = CreatePostUrlCell()
            
            urlCell.onPickImage = self.onPickImage
            self.onPickedImage = urlCell.onPickedImage
            
            return urlCell
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = Section.allCases[indexPath.row]

        switch cellType {
        case .community:
            goToChoosingCommunity?()

        default: break
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
