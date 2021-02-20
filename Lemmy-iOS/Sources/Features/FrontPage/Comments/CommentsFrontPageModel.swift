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
    var dataLoaded: (() -> Void)?
    var newDataLoaded: (() -> Void)?
    var createCommentLikeUpdate: ((_ index: Int) -> Void)?
    
    private let contentPreferenceService = ContentPreferencesStorageManager()
    
    private var isFetchingNewContent = false
    private var currentPage = 1
    
    var commentsDataSource: [LMModels.Views.CommentView] = []
    
    private let contentScoreService = ContentScoreService(userAccountService: UserAccountService())
    
    private let wsEvents = ApiManager.chainedWsCLient
    
    private var cancellable = Set<AnyCancellable>()
    
    var currentSortType: LMModels.Others.SortType {
        get { contentPreferenceService.contentSortType }
        set {
            self.currentPage = 1
            contentPreferenceService.contentSortType = newValue
        }
    }
    
    var currentListingType: LMModels.Others.ListingType {
        get { contentPreferenceService.listingType }
        set {
            self.currentPage = 1
            contentPreferenceService.listingType = newValue
        }
    }
    
    func loadComments() {
        let parameters = LMModels.Api.Comment.GetComments(type: self.currentListingType,
                                                          sort: self.currentSortType,
                                                          page: 1,
                                                          limit: 50,
                                                          communityId: nil,
                                                          communityName: nil,
                                                          auth: LemmyShareData.shared.jwtToken)
        
        ApiManager.requests.asyncGetComments(parameters: parameters)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
            } receiveValue: { (response) in
                self.commentsDataSource = response.comments
                self.dataLoaded?()
            }.store(in: &cancellable)
    }
    
    func loadMoreComments(completion: @escaping (() -> Void)) {
        let parameters = LMModels.Api.Comment.GetComments(type: self.currentListingType,
                                                          sort: self.currentSortType,
                                                          page: self.currentPage,
                                                          limit: 50,
                                                          communityId: nil,
                                                          communityName: nil,
                                                          auth: LemmyShareData.shared.jwtToken)
        
        ApiManager.requests.asyncGetComments(parameters: parameters)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
            } receiveValue: { (response) in
                self.commentsDataSource.append(contentsOf: response.comments)
                self.newDataLoaded?()
                completion()
            }.store(in: &cancellable)
    }
    
    func createCommentLike(scoreView: VoteButtonsWithScoreView, voteButton: VoteButton, for newVote: LemmyVoteType, comment: LMModels.Views.CommentView) {
        self.contentScoreService.voteComment(scoreView: scoreView, voteButton: voteButton, for: newVote, comment: comment)
    }
    
    func receiveMessages() {
        
        wsEvents.onTextMessage.addObserver(self, completionHandler: { (operation, data) in
            switch operation {
            case LMMUserOperation.CreateCommentLike.rawValue:
                
                guard let commentLike = self.wsEvents.decodeWsType(
                    LMModels.Api.Comment.CommentResponse.self,
                    data: data
                ) else { return }
                
                DispatchQueue.main.async {
                    self.createPostLike(with: commentLike.commentView)
                }
                
            case LMMUserOperation.EditComment.rawValue,
                 LMMUserOperation.DeleteComment.rawValue,
                 LMMUserOperation.RemoveComment.rawValue:
                
                guard let newComment = self.wsEvents.decodeWsType(
                    LMModels.Api.Comment.CommentResponse.self,
                    data: data
                ) else { return }
                
                
                DispatchQueue.main.async {
                    self.updateComment(with: newComment.commentView)
                }
            default:
                break
            }
        })
    }
    
    private func createPostLike(with updatedComment: LMModels.Views.CommentView) {
        if let index = self.commentsDataSource.getElementIndex(by: updatedComment.id) {
            self.commentsDataSource[index].updateForCreatePostLike(with: updatedComment)
            self.createCommentLikeUpdate?(index)
        }
    }
    
    private func updateComment(with updatedComment: LMModels.Views.CommentView) {
        if let index = self.commentsDataSource.getElementIndex(by: updatedComment.id) {
            self.commentsDataSource[index] = updatedComment
        }
    }
    
    private func saveNewComment(_ comment: LMModels.Views.CommentView) {
        if let index = commentsDataSource.firstIndex(where: { $0.comment.id == comment.comment.id }) {
            commentsDataSource[index] = comment
        }
    }
}

extension CommentsFrontPageModel: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
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
