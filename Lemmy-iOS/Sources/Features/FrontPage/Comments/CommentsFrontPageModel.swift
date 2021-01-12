//
//  CommentsFrontPageModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

class CommentsFrontPageModel: NSObject {
    var dataLoaded: (([LemmyModel.CommentView]) -> Void)?
    var newDataLoaded: (([LemmyModel.CommentView]) -> Void)?
    
    private let contentPreferenceService = ContentPreferencesStorageManager()
    
    private var isFetchingNewContent = false
    private var currentPage = 1
    
    var commentsDataSource: [LemmyModel.CommentView] = []
    
    private let contentScoreService = ContentScoreService(userAccountService: UserAccountService())

    private var cancellable = Set<AnyCancellable>()
    
    var currentSortType: LemmySortType {
        get { contentPreferenceService.contentSortType }
        set {
            self.currentPage = 1
            contentPreferenceService.contentSortType = newValue
        }
    }
    
    var currentListingType: LemmyListingType {
        get { contentPreferenceService.listingType }
        set {
            self.currentPage = 1
            contentPreferenceService.listingType = newValue
        }
    }

    func loadComments() {
        let parameters = LemmyModel.Comment.GetCommentsRequest(type: self.currentListingType,
                                                               sort: self.currentSortType,
                                                               page: 1,
                                                               limit: 50,
                                                               auth: LemmyShareData.shared.jwtToken)
        
        ApiManager.requests.asyncGetComments(parameters: parameters)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
            } receiveValue: { (response) in
                self.commentsDataSource = response.comments
                self.dataLoaded?(response.comments)
            }.store(in: &cancellable)
    }
    
    func loadMoreComments(completion: @escaping (() -> Void)) {
        let parameters = LemmyModel.Comment.GetCommentsRequest(type: self.currentListingType,
                                                               sort: self.currentSortType,
                                                               page: self.currentPage,
                                                               limit: 50,
                                                               auth: LemmyShareData.shared.jwtToken)
        
        ApiManager.requests.asyncGetComments(parameters: parameters)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
            } receiveValue: { (response) in
                self.newDataLoaded?(response.comments)
                completion()
            }.store(in: &cancellable)
    }
    
    func createCommentLike(newVote: LemmyVoteType, comment: LemmyModel.CommentView) {
        self.contentScoreService.createCommentLike(vote: newVote, contentId: comment.id)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                print(completion)
            } receiveValue: { (comment) in
                self.saveNewComment(comment)
            }.store(in: &cancellable)
    }
    
    private func saveNewComment(_ comment: LemmyModel.CommentView) {
        if let index = commentsDataSource.firstIndex(where: { $0.id == comment.id }) {
            commentsDataSource[index] = comment
        }
    }
    
}

extension CommentsFrontPageModel: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleDidSelectForComments(indexPath: indexPath)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // TODO(uuttff8): go to comments
    private func handleDidSelectForComments(indexPath: IndexPath) { }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let indexPathRow = indexPath.row
        let bottomItems = self.commentsDataSource.count - 5
        
        if indexPathRow >= bottomItems {
            guard !self.isFetchingNewContent else { return }
            
            self.isFetchingNewContent = true
            self.currentPage += 1
            self.loadMoreComments {
                self.isFetchingNewContent = false
            }
        }
    }
}

extension CommentsFrontPageModel: FrontPageHeaderCellDelegate {
    func contentTypeChanged(to content: LemmyContentType) {
        
    }
}
