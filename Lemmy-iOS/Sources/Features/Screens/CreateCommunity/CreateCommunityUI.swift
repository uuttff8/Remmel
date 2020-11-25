//
//  CreateCommunityUI.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 28.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

protocol CreateCommunityViewDelegate: SettingsTableViewDelegate { }

extension CreateCommunityUI {
    struct Appearance {
    }
}

// MARK: - CreateCommunityUI: UIView -
class CreateCommunityUI: UIView {
    
    // MARK: - Properties
    
    let appearance: Appearance
    
    weak var delegate: CreateCommunityViewDelegate? {
        didSet {
            self.tableView.delegate = self.delegate
        }
    }
    
    private lazy var tableView = SettingsTableView(appearance: .init(style: .insetGrouped))
    
//    var goToChoosingCategory: (() -> Void)?
//
//    var onPickImage: ((CreateCommunityImagesCell.ImagePick) -> Void)?
//    var onPickedImage: ((UIImage, CreateCommunityImagesCell.ImagePick) -> Void)?
//
//    let nameCell = CreateCommunityNameCell()
//    let displayNameCell = CreateCommunityDisplayNameCell()
//    let categoryCell = CreateCommunityChooseCategoryCell()
//    let imagesCell = CreateCommunityImagesCell()
//    lazy var sidebarCell = CreateCommunitySidebarCell(backView: self)
//    let nsfwCell = LemmyLabelWithSwitchCell()
//
//    // MARK: Cell type
//    enum CellSection: CaseIterable {
//        case name, displayName, category, iconsAndSidebar
//    }
//
//    enum CellRow: CaseIterable {
//        case iconAndBanner, sidebar, nsfw
//    }

    // MARK: - Init
    init(
        frame: CGRect = .zero,
        appearance: Appearance = Appearance()
    ) {
        self.appearance = appearance
        super.init(frame: .zero)
        
        self.setupView()
        self.addSubviews()
        self.makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewModel: SettingsTableViewModel) {
        self.tableView.configure(viewModel: viewModel)
    }
}

//extension CreateCommunityUI: UITableViewDelegate, UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 4
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let type = CellSection.allCases[section]
//
//        switch type {
//        case .displayName, .name, .category: return 1
//        case .iconsAndSidebar:
//
//            return CellRow.allCases.count
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let type = CellSection.allCases[indexPath.section]
//
//        switch type {
//        case .name: return nameCell
//        case .displayName: return displayNameCell
//        case .category:
//            let cell = categoryCell
//            categoryCell.bind(with: .init(title: "Choose Category"), showDisclosure: true)
//
//            model.selectedCategory
//                .receive(on: RunLoop.main)
//                .sink { (categor) in
//                    guard let categor = categor else { return }
//                    cell.bind(with: .init(title: categor.name), showDisclosure: true)
//                }.store(in: &cancellable)
//
//            return cell
//        case .iconsAndSidebar:
//
//            let row = CellRow.allCases[indexPath.row]
//
//            switch row {
//            case .iconAndBanner:
//
//                imagesCell.onPickImage = {
//                    self.onPickImage?($0)
//                }
//
//                self.onPickedImage = { image, imagePick in
//                    self.imagesCell.onPickedImage?(image, imagePick)
//                }
//
//                return imagesCell
//            case .sidebar:
//                return sidebarCell
//            case .nsfw:
//                nsfwCell.customView.checkText = "NSFW"
//                return nsfwCell
//            }
//
//        }
//    }
//
//    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        let type = CellSection.allCases[section]
//
//        switch type {
//        case .name:
//            return "Name – used as the identifier for the community, cannot be changed. Lowercase and underscore only"
//        case .displayName:
//            return "Display name — shown as the title on the community's page, can be changed."
//        default:
//            return nil
//        }
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let type = CellSection.allCases[section]
//
//        switch type {
//        case .category:
//            return "Category"
//        default:
//            return nil
//        }
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let type = CellSection.allCases[indexPath.section]
//
//        switch type {
//        case .category:
//            self.goToChoosingCategory?()
//        default:
//            break
//        }
//
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//}

extension CreateCommunityUI: ProgrammaticallyViewProtocol {
    func setupView() {
        
    }
    
    func addSubviews() {
        self.addSubview(tableView)
    }
    
    func makeConstraints() {
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
