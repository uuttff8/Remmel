//
//  CreatePostUI.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 20.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol CreatePostViewDelegate: SettingsTableViewDelegate { }

extension CreatePostScreenUI {
    struct Appearance { }
}

class CreatePostScreenUI: UIView {

    // MARK: - Properties
    let appearance: Appearance
//    var goToChoosingCommunity: (() -> Void)?
//    var onPickImage: (() -> Void)?
//    var onPickedImage: ((UIImage) -> Void)?

    weak var delegate: CreatePostViewDelegate? {
        didSet {
            self.tableView.delegate = self.delegate
        }
    }
    
    private lazy var tableView = SettingsTableView(appearance: .init(style: .insetGrouped))
//    let model: CreatePostScreenModel

//    let communityCell = CreatePostCommunityCell()
//    lazy var contentCell = CreatePostContentCell(backView: self)

    // MARK: - Init
    init(frame: CGRect = .zero, appearance: Appearance = Appearance()) {
        self.appearance = appearance
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrided
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.tableView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
//    }

    // MARK: - Private API
//    private func setupTableView() {
//        self.addSubview(tableView)
//        tableView.delegate = self
//        tableView.dataSource = self
//    }
}

// MARK: - Data source actions -
//extension CreatePostScreenUI: UITableViewDelegate, UITableViewDataSource {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        Section.allCases.count
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let section = Section.allCases[indexPath.section]
//
//        switch section {
//        case .community:
//            let cell = communityCell
//            model.communitySelectedCompletion = { community in
//                cell.bind(with: community)
//            }
//
//            return cell
//        case .url:
//            let urlCell = CreatePostUrlCell()
//
//            urlCell.onPickImage = self.onPickImage
//            self.onPickedImage = urlCell.onPickedImage
//
//            return urlCell
//        default:
//            return UITableViewCell()
//        }
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cellType = Section.allCases[indexPath.row]
//
//        switch cellType {
//        case .community:
//            goToChoosingCommunity?()
//
//        default: break
//        }
//
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//}

extension CreatePostScreenUI: ProgrammaticallyViewProtocol {
    func addSubviews() {
        self.addSubview(self.tableView)
    }

    func makeConstraints() {
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
