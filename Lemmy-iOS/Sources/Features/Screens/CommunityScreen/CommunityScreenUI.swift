//
//  CommunityScreenUI.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 15.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol CommunityScreenViewDelegate: AnyObject {
    func communityViewDidReadMoreTapped(_ communityView: CommunityScreenViewController.View, toVc: MarkdownParsedViewController)
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
        
        var contentType: LemmySortType = .active
        
        private lazy var tableView = LemmyTableView(style: .plain).then {
            $0.delegate = self
            $0.registerClass(PostContentTableCell.self)
        }
        
        var communityHeaderViewData: LemmyModel.CommunityView? {
            didSet {
                let view = CommunityTableHeaderView()
                
                view.communityHeaderView.descriptionReadMoreButton.addAction(UIAction(handler: { (_) in
                    if let desc = self.communityHeaderViewData.require().description {
                        
                        let vc = MarkdownParsedViewController(mdString: desc)
                        self.delegate?.communityViewDidReadMoreTapped(self, toVc: vc)
                    }
                }), for: .touchUpInside)
                
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
        
        init() {
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
        
        override func layoutSubviews() {
            super.layoutSubviews()
            self.tableView.layoutTableHeaderView()
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
            make.edges.equalToSuperview()
        }
    }
}

extension CommunityScreenViewController.View: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleDidSelectForPosts(indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //        guard !postsSubject.isEmpty else { return }
        //
        //        let indexPathRow = indexPath.row
        //        let bottomItems = self.postsSubject.count - 5
        //
        //        if indexPathRow >= bottomItems {
        //            guard !self.isFetchingNewContent else { return }
        //
        //            self.isFetchingNewContent = true
        //            self.currentPage += 1
        //            self.loadMorePosts(fromId: communityId) {
        //                self.isFetchingNewContent = false
        //            }
        //        }
    }
    
    private func handleDidSelectForPosts(indexPath: IndexPath) {
        //        self.goToPostScreen?(postsSubject[indexPath.row])
    }
}

