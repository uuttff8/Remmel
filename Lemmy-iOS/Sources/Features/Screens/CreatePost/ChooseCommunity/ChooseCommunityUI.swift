//
//  ChooseCommunityUI.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 22.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol ChooseCommunityUIDelegate: AnyObject {
    func chooseView(_ chooseView: ChooseCommunityUI, didRequestSearch query: String)
}

class ChooseCommunityUI: UIView {
    // MARK: - Properties
    var dismissView: (() -> Void)?
    
    weak var delegate: ChooseCommunityUIDelegate?

    private let tableView = LemmyTableView(style: .plain, separator: true)
    private let searchBar = UISearchBar()
    private let tableViewDelegate: ChooseCommunityTableDataSource

    // MARK: - Init
    init(tableViewDelegate: ChooseCommunityTableDataSource) {
        self.tableViewDelegate = tableViewDelegate
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
    
    func updateTableViewData(dataSource: (UITableViewDataSource & UITableViewDelegate)) {
        _ = dataSource.tableView(self.tableView, numberOfRowsInSection: 0)
        //            self.emptyStateLabel.isHidden = numberOfRows != 0
        
        self.tableView.dataSource = dataSource
        self.tableView.delegate = dataSource
        self.tableView.reloadData()
    }

    // MARK: - Private API
    private func setupTableView() {
        self.addSubview(tableView)
    }

    private func setupSearchController() {
        self.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.placeholder = "Search"
    }

    // MARK: Actions
    @objc private func reload(_ searchBar: UISearchBar) {
        if let text = searchBar.text, text != "" {
            tableViewDelegate.shouldShowFiltered = true
            self.delegate?.chooseView(self, didRequestSearch: text)
        } else {
            tableViewDelegate.shouldShowFiltered = false
            tableViewDelegate.removeFilteredCommunities()
        }
    }
}

extension ChooseCommunityUI: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.restore()
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(reload(_:)),
                                               object: searchBar)
        self.perform(#selector(reload(_:)), with: searchBar, afterDelay: 0.5)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableViewDelegate.shouldShowFiltered = false
        searchBar.text = ""
        tableViewDelegate.removeFilteredCommunities()
        searchBar.resignFirstResponder()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    public func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        tableViewDelegate.shouldShowFiltered = false
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tableViewDelegate.shouldShowFiltered = false
        searchBar.setShowsCancelButton(false, animated: true)
    }
}
