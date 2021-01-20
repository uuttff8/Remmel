//
//  ProfileScreenAboutUI.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 12.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

extension ProfileScreenAboutViewController.View {
    struct Appearance {
        
    }
}

extension ProfileScreenAboutViewController {
    
    class View: UIView {
        struct ViewData {
            let subscribers: [LMModels.Views.CommunityFollowerView]
        }
        
        let appearance: Appearance
        
        // Proxify delegates
        private weak var pageScrollViewDelegate: UIScrollViewDelegate?
        
        private lazy var tableView = LemmyTableView(style: .plain, separator: false).then {
            $0.registerClass(UITableViewCell.self)
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
            $0.delegate = self
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0) // tab bar
        }
        
        init(frame: CGRect = .zero, appearance: Appearance = Appearance()) {
            self.appearance = appearance
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

            self.tableView.dataSource = dataSource
            self.tableView.reloadData()
        }
    }
}

extension ProfileScreenAboutViewController.View: ProgrammaticallyViewProtocol {
    func addSubviews() {
        self.addSubview(tableView)
    }
    
    func makeConstraints() {
        self.tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide) // tab bar
        }
    }
}

extension ProfileScreenAboutViewController.View: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.pageScrollViewDelegate?.scrollViewDidScroll?(scrollView)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ProfileScreenAboutViewController.View: ProfileScreenScrollablePageViewProtocol {
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
