//
//  CommunityScreenUI.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 15.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol CommunityScreenViewDelegate: CommunityTableHeaderViewDelegate {
    func communityViewDidReadMoreTapped(
        _ communityView: CommunityScreenViewController.View,
        toVc: UIViewController
    )
    func communityViewDidPickerTapped(_ communityView: CommunityScreenViewController.View, toVc: UIViewController)
    func communityView(_ view: CommunityScreenViewController.View, didPickedNewSort type: LMModels.Others.SortType)
}

extension CommunityScreenViewController.View {
    struct Appearance {
        let estimatedRowHeight = PostContentPreviewTableCell.estimatedHeight
    }
}

extension CommunityScreenViewController {
    
    class View: UIView {
        
        private let appearance: Appearance
        
        struct HeaderViewData {
            let communityView: LMModels.Views.CommunityView
        }
        
        struct TableViewData {
            let posts: [LMModels.Views.PostView]
        }
        
        weak var delegate: CommunityScreenViewDelegate?
        
        open var contentType: LMModels.Others.SortType = .active
        
        weak var tableManager: CommunityScreenTableDataSource?
        
        private lazy var communityHeaderView = CommunityTableHeaderView()
                
        private lazy var tableView = LemmyTableView(style: .plain).then {
            $0.delegate = tableManager
            $0.registerClass(PostContentPreviewTableCell.self)
        }
        
        private lazy var emptyStateLabel = UILabel().then {
            $0.text = "nodata-posts".localized
            $0.textAlignment = .center
            $0.textColor = .tertiaryLabel
        }
        
        var communityHeaderViewData: LMModels.Views.CommunityView? {
            didSet {
                communityHeaderView.delegate = self.delegate
                communityHeaderView.bindData(community: communityHeaderViewData.require())
                tableView.tableHeaderView = communityHeaderView
            }
        }
        
        init(appearance: Appearance = Appearance(), tableManager: CommunityScreenTableDataSource) {
            self.appearance = appearance
            self.tableManager = tableManager
            super.init(frame: .zero)
            
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
        
        func updateForPostLike(at index: Int) {
            guard let tableManager = tableManager else {
                return
            }
            
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = self.tableView.cellForRow(at: indexPath) as? PostContentPreviewTableCell {
                cell.updateForCreatePostLike(post: tableManager.viewModels[index])
            }
        }
        
        func updateTableViewData(dataSource: UITableViewDataSource) {
            hideLoadingIndicator()
            emptyStateLabel.isHidden = true
            _ = dataSource.tableView(self.tableView, numberOfRowsInSection: 0)
            //            self.emptyStateLabel.isHidden = numberOfRows != 0
            
            tableView.dataSource = dataSource
            tableView.reloadData()
            tableView.layoutTableHeaderView()
        }
        
        func appendNew(data: [LMModels.Views.PostView]) {
            self.tableManager?.appendNew(posts: data) { newIndexpaths in
                tableView.performBatchUpdates {
                    tableView.insertRows(at: newIndexpaths, with: .none)
                }
            }
        }
        
        func deleteAllContent() {
            tableManager?.viewModels = []
            tableView.reloadData()
        }
        
        func displayNoData() {
            emptyStateLabel.isHidden = false
            hideLoadingIndicator()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            tableView.layoutTableHeaderView()
        }
        
        @objc func descriptionMoreButtonTapped(_ sender: UIButton) {
            if let desc = self.communityHeaderViewData.require().community.description {
                
                let vc = MarkdownParsedViewController(mdString: desc)
                let nc = StyledNavigationController(rootViewController: vc)
                delegate?.communityViewDidReadMoreTapped(self, toVc: nc)
            }
        }
    }
}

extension CommunityScreenViewController.View: ProgrammaticallyViewProtocol {
    func setupView() {
        
        communityHeaderView.communityHeaderView.descriptionReadMoreButton
            .addTarget(self, action: #selector(descriptionMoreButtonTapped), for: .touchUpInside)
        
        communityHeaderView.contentTypeView.addTap {
            let vc = self.communityHeaderView.contentTypeView.configuredAlert
            self.delegate?.communityViewDidPickerTapped(self, toVc: vc)
        }

        communityHeaderView.contentTypeView.newCasePicked = { newCase in
            self.contentType = newCase
            self.delegate?.communityView(self, didPickedNewSort: newCase)
        }
                
        emptyStateLabel.isHidden = true
        tableView.estimatedRowHeight = self.appearance.estimatedRowHeight
    }
    
    func addSubviews() {
        self.addSubview(tableView)
        self.addSubview(emptyStateLabel)
    }
    
    func makeConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        emptyStateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(350)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
