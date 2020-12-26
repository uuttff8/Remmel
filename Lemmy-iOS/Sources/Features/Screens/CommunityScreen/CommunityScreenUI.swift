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
}

extension CommunityScreenViewController {
    
    class View: UIView {
        
        struct HeaderViewData {
            let community: LemmyModel.CommunityView
        }
        
        struct TableViewData {
            let posts: [LemmyModel.PostView]
        }
        
        weak var delegate: CommunityScreenViewDelegate?
        
        open var contentType: LemmySortType = .active
        
        weak var tableViewDelegate: CommunityScreenTableDataSource?
        
        private lazy var tableView = LemmyTableView(style: .plain).then {
            $0.delegate = tableViewDelegate
            $0.registerClass(PostContentPreviewTableCell.self)
        }
        
        var communityHeaderViewData: LemmyModel.CommunityView? {
            didSet {
                let view = CommunityTableHeaderView()
                view.delegate = delegate
                
                view.communityHeaderView.descriptionReadMoreButton
                    .addTarget(self, action: #selector(descriptionMoreButtonTapped), for: .touchUpInside)
                
                view.contentTypeView.addTap {
                    let vc = view.contentTypeView.configuredAlert
                    self.delegate?.communityViewDidPickerTapped(self, toVc: vc)
                }

                view.contentTypeView.newCasePicked = { newCase in
                    self.contentType = newCase
                }
                
                view.bindData(community: communityHeaderViewData.require())
                tableView.tableHeaderView = view
                tableView.layoutTableHeaderView()
            }
        }
        
        init(tableViewDelegate: CommunityScreenTableDataSource) {
            self.tableViewDelegate = tableViewDelegate
            super.init(frame: .zero)
            
            self.setupView()
            self.addSubviews()
            self.makeConstraints()
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func showLoadingView() {
            tableView.showActivityIndicator()
        }
        
        func hideLoadingView() {
            tableView.hideActivityIndicator()
        }
        
        func updateTableViewData(dataSource: UITableViewDataSource) {
            _ = dataSource.tableView(self.tableView, numberOfRowsInSection: 0)
            //            self.emptyStateLabel.isHidden = numberOfRows != 0
            
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
        
        @objc func descriptionMoreButtonTapped(_ sender: UIButton) {
            if let desc = self.communityHeaderViewData.require().description {
                
                let vc = MarkdownParsedViewController(mdString: desc)
                let nc = StyledNavigationController(rootViewController: vc)
                self.delegate?.communityViewDidReadMoreTapped(self, toVc: nc)
            }
        }
    }
}

extension CommunityScreenViewController.View: ProgrammaticallyViewProtocol {
    func setupView() {
        
    }
    
    func addSubviews() {
        self.addSubview(tableView)
    }
    
    func makeConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
