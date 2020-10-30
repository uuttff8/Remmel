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
    
    var goToChoosingCategory: (() -> Void)?
    
    var onPickImage: ((CreateCommunityImagesCell.ImagePick) -> Void)?
    var onPickedImage: ((UIImage, CreateCommunityImagesCell.ImagePick) -> Void)?
    
    let nameCell = CreateCommunityNameCell()
    let displayNameCell = CreateCommunityDisplayNameCell()
    let categoryCell = CreateCommunityChooseCategoryCell()
    let imagesCell = CreateCommunityImagesCell()
    lazy var sidebarCell = CreateCommunitySidebarCell(backView: self)
    let nsfwCell = LemmyLabelWithSwitchCell()
    
    // MARK: Cell type
    enum CellSection: CaseIterable {
        case name, displayName, category, iconsAndSidebar
    }
    
    enum CellRow: CaseIterable {
        case iconAndBanner, sidebar, nsfw
    }
    
    // MARK: - Properties
    let tableView = LemmyTableView(style: .grouped, separator: true)
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
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let type = CellSection.allCases[section]
        
        switch type {
        case .displayName, .name, .category: return 1
        case .iconsAndSidebar:
            
            return CellRow.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = CellSection.allCases[indexPath.section]
        
        switch type {
        case .name: return nameCell
        case .displayName: return displayNameCell
        case .category:
            let cell = categoryCell
            
            model.selectedCategory
                .receive(on: RunLoop.main)
                .sink { (categor) in
                    cell.bind(with: CreateCommunityChooseCategoryCell.ViewData(title: categor.name))
                }.store(in: &cancellable)
            
            return cell
        case .iconsAndSidebar:
            
            let row = CellRow.allCases[indexPath.row]
            
            switch row {
            case .iconAndBanner:
                
                imagesCell.onPickImage = {
                    self.onPickImage?($0)
                }
                
                self.onPickedImage = { image, imagePick in
                    self.imagesCell.onPickedImage?(image, imagePick)
                }
                
                return imagesCell
            case .sidebar:
                return sidebarCell
            case .nsfw:
                nsfwCell.customView.checkText = "NSFW"
                return nsfwCell
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let type = CellSection.allCases[section]
        
        switch type {
        case .name:
            return "Name – used as the identifier for the community, cannot be changed."
        case .displayName:
            return "Display name — shown as the title on the community's page, can be changed."
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let type = CellSection.allCases[section]
        
        switch type {
        case .category:
            return "Category"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = CellSection.allCases[indexPath.section]
        
        switch type {
        case .category:
            self.goToChoosingCategory?()
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
