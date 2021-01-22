//
//  ChooseCategoryUI.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 29.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

class ChooseCategoryUI: UIView {

    // MARK: - Properties
    var dismissView: (() -> Void)?

    var cancellable = Set<AnyCancellable>()

    private let tableView = LemmyTableView(style: .insetGrouped, separator: true).then {
        $0.registerClass(CreateCommunityChooseCategoryCell.self)
    }
    private let searchBar = UISearchBar().then {
        $0.isOpaque = true
        $0.barTintColor = .systemBackground
        $0.backgroundColor = .systemBackground
    }
    private let model: ChooseCategoryViewModel
    private var shouldShowFiltered = false

    var currentCellData: ((_ indexPath: IndexPath) -> LMModels.Source.Category) {
        if !model.filteredCategories.value.isEmpty {

            return { (indexPath: IndexPath) in
                self.model.filteredCategories.value[indexPath.row]
            }

        } else {

            return { indexPath in
                self.model.categories.value[indexPath.row]
            }

        }
    }

    // MARK: - Init
    init(model: ChooseCategoryViewModel) {
        self.model = model
        super.init(frame: .zero)
        setupTableView()
        setupSearchController()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrided
    override func layoutSubviews() {
        super.layoutSubviews()
        self.searchBar.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }

        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.searchBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    // MARK: - Private API
    private func setupTableView() {
        self.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self

        model.categories
            .receive(on: DispatchQueue.main)
            .sink { (_) in
                self.tableView.reloadData()
            }.store(in: &cancellable)

        model.filteredCategories
            .receive(on: DispatchQueue.main)
            .sink { (_) in
                self.tableView.reloadData()
            }.store(in: &cancellable)
    }

    private func setupSearchController() {
        self.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.placeholder = "searchbar-placeholder".localized
    }

    // MARK: Actions
    @objc func reload(_ searchBar: UISearchBar) {
        if let text = searchBar.text, text != "" {
            // TODO: make search for communities
            self.shouldShowFiltered = true
            model.searchCategories(query: text)
        } else {
            // TODO: Refactor
            self.shouldShowFiltered = false
            model.filteredCategories.value.removeAll()
        }
    }
}

extension ChooseCategoryUI: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if shouldShowFiltered {
            if model.filteredCategories.value.isEmpty {
                self.tableView.setEmptyMessage("Not found")
            }

            return model.filteredCategories.value.count
        }

        return model.categories.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = currentCellData(indexPath)

        let cell = tableView.cell(forClass: CreateCommunityChooseCategoryCell.self)
        cell.bind(with: .init(title: data.name), showDisclosure: false)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data: LMModels.Source.Category = currentCellData(indexPath)

        model.selectedCategory.send(data)
        dismissView?()

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ChooseCategoryUI: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.restore()
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(reload(_:)),
                                               object: searchBar)
        self.perform(#selector(reload(_:)), with: searchBar, afterDelay: 0.5)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowFiltered = false
        searchBar.text = ""
        model.filteredCategories.value.removeAll()
        searchBar.resignFirstResponder()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    public func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        shouldShowFiltered = false
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        shouldShowFiltered = false
        searchBar.setShowsCancelButton(false, animated: true)
    }
}
