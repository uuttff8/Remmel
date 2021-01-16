//
//  ChooseCommunityUI.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 22.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import SnapKit

protocol ChooseCommunityUIDelegate: AnyObject {
    func chooseView(_ chooseView: ChooseCommunityUI, didRequestSearch query: String)
}
 
extension ChooseCommunityUI {
    struct Appearance {
        let loadingIndicatorInsets = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0)

        let headerViewHeight: CGFloat = 60

        let emptyStateLabelFont = UIFont.systemFont(ofSize: 17, weight: .light)
        let emptyStateLabelColor = UIColor.placeholderText
        let emptyStateLabelInsets = UIEdgeInsets(top: 0, left: 35, bottom: 0, right: 35)
    }
}

class ChooseCommunityUI: UIView {
    // MARK: - Properties
    var dismissView: (() -> Void)?
    
    weak var delegate: ChooseCommunityUIDelegate?

    let appearance: Appearance
    
    private let tableView = LemmyTableView(style: .insetGrouped, separator: true).then {
        $0.registerClass(ChooseCommunityCell.self)
    }
    private let searchBar = UISearchBar()
    private var tableManager: ChooseCommunityTableDataSource
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.hidesWhenStopped = true
        return view
    }()
    private var loadingIndicatorTopConstraint: Constraint?
    
    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Not found"
        label.numberOfLines = 0
        label.textColor = self.appearance.emptyStateLabelColor
        label.font = self.appearance.emptyStateLabelFont
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    // MARK: - Init
    init(tableManager: ChooseCommunityTableDataSource, appearance: Appearance = Appearance()) {
        self.appearance = appearance
        self.tableManager = tableManager
        super.init(frame: .zero)
        setupSearchController()
        
        setupView()
        addSubviews()
        makeConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTableViewData(dataSource: (UITableViewDataSource & UITableViewDelegate)) {
        self.hideNotFound()
        _ = dataSource.tableView(self.tableView, numberOfRowsInSection: 0)
        //            self.emptyStateLabel.isHidden = numberOfRows != 0
        
        self.tableView.dataSource = dataSource
        self.tableView.delegate = dataSource
        self.tableView.reloadData()
    }
    
    func showNotFound() {
        self.tableView.isHidden = true
        self.emptyStateLabel.isHidden = false
    }

    func hideNotFound() {
        self.tableView.isHidden = false
        self.emptyStateLabel.isHidden = true
    }
    
    // MARK: - Private API
    private func setupSearchController() {
        self.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.placeholder = "Search"
    }

    // MARK: Actions
    @objc private func reload(_ searchBar: UISearchBar) {
        self.hideActivityIndicatorView()
        if let text = searchBar.text, text != "" {
            self.hideActivityIndicatorView()
            tableManager.shouldShowFiltered = true
            tableManager.removeFilteredCommunities()
            tableView.reloadData()
            self.delegate?.chooseView(self, didRequestSearch: text)
        } else {
            tableManager.shouldShowFiltered = false
            tableManager.removeFilteredCommunities()
            tableView.reloadData()
        }
    }
}

extension ChooseCommunityUI: ProgrammaticallyViewProtocol {
    func setupView() {
        self.backgroundColor = .systemBackground
    }
    
    func addSubviews() {
        self.addSubview(self.tableView)
        self.addSubview(self.emptyStateLabel)
        self.addSubview(self.loadingIndicator)
    }
    
    func makeConstraints() {
        self.searchBar.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }

        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.searchBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        self.emptyStateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading
                .greaterThanOrEqualToSuperview()
                .offset(self.appearance.emptyStateLabelInsets.left)
                .priority(999)
            make.trailing
                .lessThanOrEqualToSuperview()
                .offset(-self.appearance.emptyStateLabelInsets.right)
                .priority(999)
            make.width.lessThanOrEqualTo(600)
        }

        self.loadingIndicator.snp.makeConstraints { make in
            self.loadingIndicatorTopConstraint = make.top
                .equalToSuperview()
                .offset(self.appearance.loadingIndicatorInsets.top).constraint
            make.centerX.equalToSuperview()
        }
    }
    
}

extension ChooseCommunityUI: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.showActivityIndicatorView()
        
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(reload(_:)),
                                               object: searchBar)
        self.perform(#selector(reload(_:)), with: searchBar, afterDelay: 0.5)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableManager.shouldShowFiltered = false
        searchBar.text = ""
        tableManager.removeFilteredCommunities()
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    public func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        tableManager.shouldShowFiltered = false
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tableManager.shouldShowFiltered = false
        searchBar.setShowsCancelButton(false, animated: true)
    }
}
