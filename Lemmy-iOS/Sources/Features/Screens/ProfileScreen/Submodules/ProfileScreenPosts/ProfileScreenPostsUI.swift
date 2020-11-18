//
//  ProfileScreenPostsUI.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol ProfileScreenPostsViewDelegate: AnyObject {
    func profileScreenPostsViewDidPickerTapped(toVc: UIViewController)
}

extension ProfileScreenPostsViewController.View {
    struct Appearance {
        
    }
}

extension ProfileScreenPostsViewController {
    
    class View: UIView {
        
        struct ViewData {
            let posts: [LemmyModel.PostView]
        }
        
        weak var delegate: ProfileScreenPostsViewDelegate?
        
        let appearance: Appearance
        var contentType: LemmySortType = .active
        
        // Proxify delegates
        private weak var pageScrollViewDelegate: UIScrollViewDelegate?
        
        weak var tableViewDelegate: PostsTableDataSource?
        
        private lazy var tableView = LemmyTableView(style: .plain, separator: false).then {
            $0.registerClass(PostContentTableCell.self)
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
            $0.delegate = self
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0) // tab bar
        }
        
        private lazy var profileScreenHeader = ProfileScreenTableHeaderView().then { view in
            view.contentTypeView.addTap {
                let vc = view.contentTypeView.configuredAlert
                self.delegate?.profileScreenPostsViewDidPickerTapped(toVc: vc)
            }

            view.contentTypeView.newCasePicked = { newCase in
                self.contentType = newCase
            }
        }
        
        init(
            frame: CGRect = .zero,
            appearance: Appearance = Appearance(),
            tableViewDelegate: PostsTableDataSource
        ) {
            self.appearance = appearance
            self.tableViewDelegate = tableViewDelegate
            super.init(frame: frame)

            self.setupView()
            self.addSubviews()
            self.makeConstraints()
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func showLoadingIndicator() {
            tableView.showActivityIndicator()
        }
        
        func hideActivityIndicator() {
            tableView.hideActivityIndicator()
        }
        
        func updateTableViewData(dataSource: UITableViewDataSource) {
            _ = dataSource.tableView(self.tableView, numberOfRowsInSection: 0)
//            self.emptyStateLabel.isHidden = numberOfRows != 0

            self.tableView.tableHeaderView = profileScreenHeader
            self.tableView.dataSource = dataSource
            self.tableView.reloadData()
        }
        
        func appendNew(data: [LemmyModel.PostView]) {
            self.tableViewDelegate?.appendNew(posts: data) { (newIndexpaths) in
                tableView.performBatchUpdates {
                    tableView.insertRows(at: newIndexpaths, with: .none)
                }
            }
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            self.tableView.layoutTableHeaderView()
        }
    }
}

extension ProfileScreenPostsViewController.View: ProgrammaticallyViewProtocol {
    func setupView() {
        
    }
    
    func addSubviews() {
        self.addSubview(tableView)
    }
    
    func makeConstraints() {
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.tableView.layoutTableHeaderView()
    }
}

extension ProfileScreenPostsViewController.View: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.pageScrollViewDelegate?.scrollViewDidScroll?(scrollView)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.tableViewDelegate?.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableViewDelegate?.tableView(tableView, didSelectRowAt: indexPath)
    }
}

extension ProfileScreenPostsViewController.View: ProfileScreenScrollablePageViewProtocol {
    var scrollViewDelegate: UIScrollViewDelegate? {
        get {
             self.pageScrollViewDelegate
        }
        set {
            self.pageScrollViewDelegate = newValue
        }
    }

    var contentInsets: UIEdgeInsets {
        get {
             self.tableView.contentInset
        }
        set {
            self.tableView.contentInset = newValue

        }
    }

    var contentOffset: CGPoint {
        get {
             self.tableView.contentOffset
        }
        set {
            self.tableView.contentOffset = newValue
        }
    }

    var contentInsetAdjustmentBehavior: UIScrollView.ContentInsetAdjustmentBehavior {
        get {
             self.tableView.contentInsetAdjustmentBehavior
        }
        set {
            self.tableView.contentInsetAdjustmentBehavior = newValue
        }
    }
}
