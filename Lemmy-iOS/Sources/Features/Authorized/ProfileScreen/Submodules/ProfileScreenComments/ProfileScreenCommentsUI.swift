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
    func profileScreenComments(
        _ view: ProfileScreenCommentsViewController.View,
        didPickedNewSort type: LMModels.Others.SortType
    )
}

extension ProfileScreenCommentsViewController.View {
    struct Appearance {
        
    }
}

extension ProfileScreenCommentsViewController {
    
    class View: UIView {
        struct ViewData {
            let comments: [LMModels.Views.CommentView]
        }
        
        weak var delegate: ProfileScreenCommentsViewDelegate?
        
        let appearance: Appearance
        var sortType: LMModels.Others.SortType = .active {
            didSet {
                self.delegate?.profileScreenComments(self, didPickedNewSort: sortType)
            }
        }
        
        // Proxify delegates
        private weak var pageScrollViewDelegate: UIScrollViewDelegate?
        
        weak var tableManager: ProfileScreenCommentsTableDataSource?
        
        private lazy var tableView = LemmyTableView(style: .plain, separator: false).then {
            $0.registerClass(CommentContentTableCell.self)
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
            $0.delegate = self
            $0.tableHeaderView = commentsHeaderView
        }
        
        private lazy var commentsHeaderView = ProfileScreenTableHeaderView().then { view in
            view.contentTypeView.addTap {
                let vc = view.contentTypeView.configuredAlert
                self.delegate?.profileScreenPostsViewDidPickerTapped(toVc: vc)
            }

            view.contentTypeView.newCasePicked = { newCase in
                self.sortType = newCase
            }
        }
        
        private lazy var emptyStateLabel = UILabel().then {
            $0.text = "nodata-comments".localized
            $0.textAlignment = .center
            $0.textColor = .tertiaryLabel
        }
        
        init(
            frame: CGRect = .zero,
            tableViewManager: ProfileScreenCommentsTableDataSource,
            appearance: Appearance = Appearance()
        ) {
            self.appearance = appearance
            self.tableManager = tableViewManager
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
            self.hideLoadingIndicator()
            self.emptyStateLabel.isHidden = true
            _ = dataSource.tableView(self.tableView, numberOfRowsInSection: 0)
//            self.emptyStateLabel.isHidden = numberOfRows != 0

            self.tableView.dataSource = dataSource
            self.tableView.reloadData()
        }
        
        func displayNoData() {
            self.emptyStateLabel.isHidden = false
            self.hideLoadingIndicator()
        }
        
        func appendNew(data: [LMModels.Views.CommentView]) {
            self.tableManager?.appendNew(comments: data) { (newIndexpaths) in
                tableView.performBatchUpdates {
                    tableView.insertRows(at: newIndexpaths, with: .none)
                }
            }
        }
        
        func deleteAllContent() {
            self.tableManager?.viewModels = []
            self.tableView.reloadData()
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
        self.tableManager?.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
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
