//
//  PostsTableDataSource.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 16.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol PostsTableDataSourceDelegate: AnyObject {
    func tableDidRequestPagination(_ tableDataSource: PostsTableDataSource)
    func tableDidSelect(post: LemmyModel.PostView)
    
    func upvote(voteButton: VoteButton, post: LemmyModel.PostView)
    func downvote(voteButton: VoteButton, post: LemmyModel.PostView)
    func usernameTapped(in post: LemmyModel.PostView)
    func communityTapped(in post: LemmyModel.PostView)
    func onLinkTap(in post: LemmyModel.PostView, url: URL)
}

final class PostsTableDataSource: NSObject {
    weak var delegate: PostsTableDataSourceDelegate?
    
    var viewModels: [LemmyModel.PostView]
    
    init(viewModels: [LemmyModel.PostView] = []) {
        self.viewModels = viewModels
        super.init()
    }
    
    // MARK: - Public API
    
    func update(viewModel: LemmyModel.PostView) {
        if let index = self.viewModels.firstIndex(where: { $0.id == viewModel.id }) {
            self.viewModels[index] = viewModel
        }
    }
    
    func appendNew(posts: [LemmyModel.PostView], completion: (_ indexPaths: [IndexPath]) -> Void) {
        let startIndex = viewModels.count - posts.count
        let endIndex = startIndex + posts.count
        
        let newIndexpaths =
            Array(startIndex ..< endIndex)
            .map { (index) in
                IndexPath(row: index, section: 0)
            }
        
        completion(newIndexpaths)
    }
}

// MARK: - UITableViewDataSource -
extension PostsTableDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PostContentTableCell = tableView.cell(forRowAt: indexPath)
        cell.updateConstraintsIfNeeded()
        
        cell.postContentView.delegate = self
        
        let viewModel = self.viewModels[indexPath.row]
        cell.bind(with: viewModel, config: .insideComminity)
        
        return cell
    }
}

extension PostsTableDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = viewModels[indexPath.row]
        
        self.delegate?.tableDidSelect(post: post)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 5,
           tableView.numberOfSections == 1 {
            self.delegate?.tableDidRequestPagination(self)
        }
    }
}

extension PostsTableDataSource: PostContentTableCellDelegate {
    func upvote(voteButton: VoteButton, newVote: LemmyVoteType, post: LemmyModel.PostView) {
        self.delegate?.downvote(voteButton: voteButton, post: post)
    }
    
    func downvote(voteButton: VoteButton, newVote: LemmyVoteType, post: LemmyModel.PostView) {
        self.delegate?.upvote(voteButton: voteButton, post: post)
    }
    
    func usernameTapped(in post: LemmyModel.PostView) {
        self.delegate?.usernameTapped(in: post)
    }
    
    func communityTapped(in post: LemmyModel.PostView) {
        self.delegate?.communityTapped(in: post)
    }
    
    func onLinkTap(in post: LemmyModel.PostView, url: URL) {
        self.delegate?.onLinkTap(in: post, url: url)
    }
}
