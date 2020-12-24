//
//  ProfileScreenCommentsUI.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 11.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol ProfileScreenCommentsViewDelegate: AnyObject {
    func profileScreenPostsViewDidPickerTapped(toVc: UIViewController)
}

extension ProfileScreenCommentsViewController.View {
    struct Appearance {
        
    }
}

extension ProfileScreenCommentsViewController {
    
    class View: UIView {
        struct ViewData {
            let comments: [LemmyModel.CommentView]
        }
        
        weak var delegate: ProfileScreenCommentsViewDelegate?
        
        let appearance: Appearance
        var contentType: LemmySortType = .active
        
        // Proxify delegates
        private weak var pageScrollViewDelegate: UIScrollViewDelegate?
        
        weak var tableViewManager: ProfileScreenCommentsTableDataSource?
        
        private lazy var tableView = LemmyTableView(style: .plain, separator: false).then {
            $0.registerClass(CommentContentTableCell.self)
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
            $0.delegate = self
        }
        
        private lazy var commentsHeaderView = ProfileScreenTableHeaderView().then { view in
            view.contentTypeView.addTap {
                let vc = view.contentTypeView.configuredAlert
                self.delegate?.profileScreenPostsViewDidPickerTapped(toVc: vc)
            }

            view.contentTypeView.newCasePicked = { newCase in
                self.contentType = newCase
            }
        }
        
        private lazy var emptyStateLabel = UILabel().then {
            $0.text = "No Comments here yet..."
            $0.textAlignment = .center
            $0.textColor = .tertiaryLabel
        }
        
        init(
            frame: CGRect = .zero,
            tableViewManager: ProfileScreenCommentsTableDataSource,
            appearance: Appearance = Appearance()
        ) {
            self.appearance = appearance
            self.tableViewManager = tableViewManager
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
        
        func hideLoadingIndicator() {
            tableView.hideActivityIndicator()
        }
        
        func updateTableViewData(dataSource: UITableViewDataSource & UITableViewDelegate) {
            _ = dataSource.tableView(self.tableView, numberOfRowsInSection: 0)
//            self.emptyStateLabel.isHidden = numberOfRows != 0

            self.tableView.tableHeaderView = commentsHeaderView
            self.tableView.dataSource = dataSource
            self.tableView.reloadData()
        }
        
        func displayNoData() {
            self.emptyStateLabel.isHidden = false
            self.tableView.isHidden = true
            makeConstraints()
        }
        
        func appendNew(data: [LemmyModel.CommentView]) {
            self.tableViewManager?.appendNew(comments: data) { (newIndexpaths) in
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

extension ProfileScreenCommentsViewController.View: ProgrammaticallyViewProtocol {
    func setupView() {
        self.emptyStateLabel.isHidden = true
    }
    
    func addSubviews() {
        self.addSubview(tableView)
        self.addSubview(emptyStateLabel)
    }
    
    func makeConstraints() {
        self.tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide) // tab bar
        }
        
        self.emptyStateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(350)
            $0.leading.trailing.equalToSuperview()
        }
    }
}

extension ProfileScreenCommentsViewController.View: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.pageScrollViewDelegate?.scrollViewDidScroll?(scrollView)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.tableViewManager?.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
    }
}

extension ProfileScreenCommentsViewController.View: ProfileScreenScrollablePageViewProtocol {
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
