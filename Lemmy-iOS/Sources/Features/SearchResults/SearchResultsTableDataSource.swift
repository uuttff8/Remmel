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
    func tableDidTapped(followButton: FollowButton, in community: LMModels.Views.CommunityView)
}

final class SearchResultsTableDataSource: NSObject {
    var viewModels: SearchResults.Results
    
    weak var delegate: SearchResultsTableDataSourceDelegate?
    
    init(viewModels: SearchResults.Results = .posts([])) {
        self.viewModels = viewModels
        super.init()
    }
    
    func getUpdatedIndexPaths(objects: [Any]) -> [IndexPath] {
        let startIndex = countViewModels() - objects.count
        let endIndex = startIndex + objects.count
        
        let newIndexPaths = Array(startIndex ..< endIndex)
            .map { IndexPath(row: $0, section: 0) }
        
        return newIndexPaths
    }
    
    func appendViewModels(viewModel: SearchResults.Results) {
        switch viewModel {
        case let .comments(response):
            guard case let .comments(data) = self.viewModels else { return }
            
            viewModels = .comments(data + response)
        case let .posts(response):
            guard case let .posts(data) = self.viewModels else { return }
            
            viewModels = .posts(data + response)
        case let .communities(response):
            guard case let .communities(data) = self.viewModels else { return }

            viewModels = .communities(data + response)
        case let .users(response):
            guard case let .users(data) = self.viewModels else { return }
            
            viewModels = .users(data + response)
        }
    }
    
    private func countViewModels() -> Int {
        switch viewModels {
        case let .comments(data): return data.count
        case let .posts(data): return data.count
        case let .communities(data): return data.count
        case let .users(data): return data.count
        }
    }
        
    func saveNewPost(post: LMModels.Views.PostView) {
        guard case .posts(var data) = viewModels else { return }
        
        if let index = data.firstIndex(where: { $0.id == post.id }) {
            data[index] = post
            viewModels = .posts(data)
        }
    }
    
    func saveNewComment(comment: LMModels.Views.CommentView) {
        guard case .comments(var data) = viewModels else { return }
        
        if let index = data.firstIndex(where: { $0.comment.id == comment.comment.id }) {
            data[index] = comment
            viewModels = .comments(data)
        }
    }
    
    func saveNewCommunity(community: LMModels.Views.CommunityView) {
        guard case .communities(var data) = viewModels else { return }
        
        if let index = data.firstIndex(where: { $0.id == community.id }) {
            data[index] = community
            viewModels = .communities(data)
        }
    }
    
    private func createPostCell(
        post: LMModels.Views.PostView,
        tableView: UITableView,
        indexPath: IndexPath
    ) -> UITableViewCell {
        let cell: PostContentPreviewTableCell = tableView.cell(forRowAt: indexPath)
        cell.bind(with: post, isInsideCommunity: false)
        cell.postContentView.delegate = delegate
        return cell
    }
    
    private func createCommentCell(
        comment: LMModels.Views.CommentView,
        tableView: UITableView,
        indexPath: IndexPath
    ) -> UITableViewCell {
        let cell: CommentContentTableCell = tableView.cell(forRowAt: indexPath)
        cell.bind(with: comment, level: 0)
        cell.commentContentView.delegate = delegate
        return cell
    }
    
    private func createCommunityCell(
        community: LMModels.Views.CommunityView,
        tableView: UITableView,
        indexPath: IndexPath
    ) -> UITableViewCell {
        let cell: CommunityPreviewTableCell = tableView.cell(forRowAt: indexPath)
        cell.bind(community: community)
        cell.delegate = self
        return cell
    }
    
    private func createUserPreviewCell(
        user: LMModels.Views.PersonViewSafe,
        tableView: UITableView,
        indexPath: IndexPath
    ) -> UITableViewCell {
        let cell: UserPreviewCell = tableView.cell(forRowAt: indexPath)
        cell.configure(with: .init(name: user.person.name,
                                   numberOfComments: user.counts.commentCount,
                                   thumbailUrl: user.person.avatar))
        return cell
    }
}

extension SearchResultsTableDataSource: CommunityPreviewCellViewDelegate {
    func communityCellView(_ cell: CommunityPreviewCellView, didTapped followButton: FollowButton) {
        guard let communityCell = cell.viewData else { return }
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 5,
           tableView.numberOfSections == 1 {
            self.delegate?.tableDidRequestPagination(self)
        }
    }
}
