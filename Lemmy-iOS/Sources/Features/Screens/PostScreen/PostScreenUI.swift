//
//  PostScreenUI.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/26/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import SafariServices

extension PostScreenViewController {
    
    class View: UIView {
        
        struct ViewData {
            let post: LemmyModel.PostView
            let comments: [CommentNode]
        }
        
        fileprivate var headerView: PostScreenUITableCell!
        
        var presentOnVc: ((UIViewController) -> Void)?
        var dismissOnVc: (() -> Void)?
        
        lazy var tableView = LemmyTableView(style: .plain).then {
            $0.delegate = self
            $0.registerClass(CommentTreeTableCell.self)
        }
        
        var postInfo: LemmyModel.PostView? {
            didSet {
                headerView = PostScreenUITableCell(post: postInfo.require())
                headerView.postHeaderView.delegate = self
                tableView.tableHeaderView = headerView
                
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
                
        private func openLink(urlString: String?) {
            if let str = urlString, let url = URL(string: str) {
                
                let vc = SFSafariViewController(url: url)
                vc.delegate = self
                
                presentOnVc?(vc)
            }
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            self.tableView.layoutTableHeaderView()
        }
    }
}

extension PostScreenViewController.View: ProgrammaticallyViewProtocol {
    func addSubviews() {
        self.addSubview(tableView)
    }
    
    func makeConstraints() {
        self.tableView.snp.makeConstraints { (make) in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}

extension PostScreenViewController.View: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.dismissOnVc?()
    }
}

extension PostScreenViewController.View: UITableViewDelegate {    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

private class PostScreenUITableCell: UIView {
    
    let postHeaderView = PostContentView()
    private(set) lazy var postGreenOutlineView = LemmyGreenOutlinePostEmbed(
        with:
            LemmyGreenOutlinePostEmbed.Data(
                title: postInfo.embedTitle,
                description: postInfo.embedDescription,
                url: postInfo.url
            )
    )
    
    let postInfo: LemmyModel.PostView
    
    init(post: LemmyModel.PostView) {
        self.postInfo = post
        super.init(frame: .zero)
        
        setupView()
        addSubviews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PostScreenUITableCell: ProgrammaticallyViewProtocol {
    func setupView() {
        self.backgroundColor = UIColor.systemBackground
        postHeaderView.bind(with: postInfo, config: .fullPost)
    }
    
    func addSubviews() {
        self.addSubview(postHeaderView)
        self.addSubview(postGreenOutlineView)
    }
    
    func makeConstraints() {
        self.postHeaderView.snp.makeConstraints { (make) in
            make.top.trailing.leading.equalToSuperview()
        }
        
        if !postGreenOutlineView.isHidden {
            self.postGreenOutlineView.snp.makeConstraints { (make) in
                make.top.equalTo(postHeaderView.snp.bottom).offset(10)
                make.trailing.leading.equalToSuperview().inset(10)
                make.bottom.equalToSuperview()
            }
        } else {
            self.postHeaderView.snp.remakeConstraints { (make) in
                make.top.trailing.leading.bottom.equalToSuperview()
            }
        }
    }
}

extension PostScreenViewController.View: PostContentTableCellDelegate {
    func upvote(voteButton: VoteButton, newVote: LemmyVoteType, post: LemmyModel.PostView) {
        
    }
    
    func downvote(voteButton: VoteButton, newVote: LemmyVoteType, post: LemmyModel.PostView) {
        
    }
    
    func usernameTapped(in post: LemmyModel.PostView) {
        
    }
    
    func communityTapped(in post: LemmyModel.PostView) {
        
    }
    
    func onLinkTap(in post: LemmyModel.PostView, url: URL) {
        let safariVc = SFSafariViewController(url: url)
        safariVc.delegate = self
        presentOnVc?(safariVc)
    }
}
