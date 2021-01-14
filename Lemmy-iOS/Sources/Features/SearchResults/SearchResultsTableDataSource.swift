//
//  SearchResultsTableDataSource.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 03.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol SearchResultsTableDataSourceDelegate: PostContentPreviewTableCellDelegate, CommentContentTableCellDelegate {
    func tableDidRequestPagination(_ tableDataSource: SearchResultsTableDataSource)
    func tableDidSelect(viewModel: SearchResults.Results, indexPath: IndexPath)
    func tableDidTapped(followButton: FollowButton, in community: LemmyModel.CommunityView)
}

final class SearchResultsTableDataSource: NSObject {
    var viewModels: SearchResults.Results
    
    weak var delegate: SearchResultsTableDataSourceDelegate?
    
    init(viewModels: SearchResults.Results = .posts([])) {
        self.viewModels = viewModels
        super.init()
    }
    
    func appendNew(objects: [AnyObject] = []) -> [IndexPath] {
        let startIndex = countViewModels() - objects.count
        let endIndex = startIndex + objects.count
        
        let newIndexPaths = Array(startIndex ..< endIndex)
            .map { IndexPath(row: $0, section: 0) }
        
        return newIndexPaths
    }
    
    private func countViewModels() -> Int {
        switch viewModels {
        case let .comments(data): return data.count
        case let .posts(data): return data.count
        case let .communities(data): return data.count
        case let .users(data): return data.count
        }
    }
        
    func saveNewPost(post: LemmyModel.PostView) {
        guard case .posts(var data) = viewModels else { return }
        
        if let index = data.firstIndex(where: { $0.id == post.id }) {
            data[index] = post
            viewModels = .posts(data)
        }
    }
    
    func saveNewComment(comment: LemmyModel.CommentView) {
        guard case .comments(var data) = viewModels else { return }
        
        if let index = data.firstIndex(where: { $0.id == comment.id }) {
            data[index] = comment
            viewModels = .comments(data)
        }
    }
    
    func saveNewCommunity(community: LemmyModel.CommunityView) {
        guard case .communities(var data) = viewModels else { return }
        
        if let index = data.firstIndex(where: { $0.id == community.id }) {
            data[index] = community
            viewModels = .communities(data)
        }
    }
    
    private func createPostCell(
        post: LemmyModel.PostView,
        tableView: UITableView,
        indexPath: IndexPath
    ) -> UITableViewCell {
        let cell: PostContentPreviewTableCell = tableView.cell(forRowAt: indexPath)
        cell.bind(with: post, isInsideCommunity: false)
        cell.postContentView.delegate = delegate
        return cell
    }
    
    private func createCommentCell(
        comment: LemmyModel.CommentView,
        tableView: UITableView,
        indexPath: IndexPath
    ) -> UITableViewCell {
        let cell: CommentContentTableCell = tableView.cell(forRowAt: indexPath)
        cell.bind(with: comment, level: 0)
        cell.commentContentView.delegate = delegate
        return cell
    }
    
    private func createCommunityCell(
        community: LemmyModel.CommunityView,
        tableView: UITableView,
        indexPath: IndexPath
    ) -> UITableViewCell {
        let cell: CommunityPreviewTableCell = tableView.cell(forRowAt: indexPath)
        cell.bind(community: community)
        cell.delegate = self
        return cell
    }
    
    private func createUserPreviewCell(
        user: LemmyModel.UserView,
        tableView: UITableView,
        indexPath: IndexPath
    ) -> UITableViewCell {
        let cell: UserPreviewCell = tableView.cell(forRowAt: indexPath)
        cell.configure(with: .init(name: user.name,
                                   numberOfComments: user.numberOfComments,
                                   thumbailUrl: user.avatar))
        return cell
    }
}

extension SearchResultsTableDataSource: CommunityPreviewTableCellDelegate {
    func communityPreviewCell(_ cell: CommunityPreviewTableCell, didTapped followButton: FollowButton) {
        guard let communityCell = cell.community else { return }
        guard case .communities(let viewModels) = viewModels else { return }
        
        if let index = viewModels.firstIndex(where: { $0.id == communityCell.id }) {
            self.delegate?.tableDidTapped(followButton: followButton, in: viewModels[index])
        }
    }
}

extension SearchResultsTableDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.countViewModels()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch viewModels {
        case let .comments(data):
            return createCommentCell(comment: data[indexPath.row], tableView: tableView, indexPath: indexPath)
        case let .posts(data):
            return createPostCell(post: data[indexPath.row], tableView: tableView, indexPath: indexPath)
        case let .communities(data):
            return createCommunityCell(community: data[indexPath.row], tableView: tableView, indexPath: indexPath)
        case let .users(data):
            return createUserPreviewCell(user: data[indexPath.row], tableView: tableView, indexPath: indexPath)
        }
    }
}

extension SearchResultsTableDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.tableDidSelect(viewModel: viewModels, indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
