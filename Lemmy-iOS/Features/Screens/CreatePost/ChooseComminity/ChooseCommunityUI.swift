//
//  ChooseCommunityUI.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 22.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class ChooseCommunityUI: UIView {
    // MARK: - Properties
    private let tableView = LemmyTableView(style: .plain, separator: true)
    private let searchBar = UISearchBar()
    private let model: CreatePostScreenModel
    
    // MARK: - Init
    init(model: CreatePostScreenModel) {
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
        
        model.communitiesLoaded = { newCommunities in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func setupSearchController() {
        self.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.placeholder = "Search"
    }
    
    // MARK: Actions
    @objc func reload(_ searchBar: UISearchBar) {
        if let text = searchBar.text, text != "" {
            // TODO: make search for communities
            model.searchCommunities(query: text)
        } else {
            
        }
    }
}

extension ChooseCommunityUI: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.communitiesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = model.communitiesData[indexPath.row]
        
        let cell = ChooseCommunityCell()
        cell.bind(with: ChooseCommunityCell.ViewData(title: data.title, icon: data.icon))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = model.communitiesData[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ChooseCommunityUI: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(reload(_:)),
                                               object: searchBar)
        self.perform(#selector(reload(_:)), with: searchBar, afterDelay: 0.5)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    public func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
}
