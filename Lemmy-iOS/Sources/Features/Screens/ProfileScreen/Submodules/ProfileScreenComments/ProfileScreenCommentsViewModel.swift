//
//  ProfileScreenCommentsViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 11.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

protocol ProfileScreenCommentsViewModelProtocol {
    // TODO do pagination
    func doProfileCommentsFetch()
    func doCommentLike(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        for newVote: LemmyVoteType,
        comment: LemmyModel.CommentView
    )
}

class ProfileScreenCommentsViewModel: ProfileScreenCommentsViewModelProtocol {
    weak var viewController: ProfileScreenCommentsViewControllerProtocol?
    
    private let contentScoreService: ContentScoreServiceProtocol
    
    var cancellable = Set<AnyCancellable>()
    
    init(
        contentScoreService: ContentScoreServiceProtocol
    ) {
        self.contentScoreService = contentScoreService
    }
    
    func doProfileCommentsFetch() { }
    
    func doCommentLike(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        for newVote: LemmyVoteType,
        comment: LemmyModel.CommentView
    ) {
        self.contentScoreService.voteComment(
            scoreView: scoreView,
            voteButton: voteButton,
            for: newVote,
            comment: comment
        ) { (comment) in
            // self.saveNewComment()
        }
    }
}

extension ProfileScreenCommentsViewModel: ProfileScreenCommentsInputProtocol {
    func updateFirstData(
        posts: [LemmyModel.PostView],
        comments: [LemmyModel.CommentView],
        subscribers: [LemmyModel.CommunityFollowerView]
    ) {
        self.viewController?.displayProfileComments(
            viewModel: .init(state: .result(data: .init(comments: comments)))
        )
    }
    
    func registerSubmodule() { }
    
    func handleControllerAppearance() { }
}

class ProfileScreenComments {
    enum CommentsLoad {
        struct Response {
            let comments: [LemmyModel.CommentView]
        }
        
        struct ViewModel {
            let state: ViewControllerState
        }
    }
    
    // MARK: States
    enum ViewControllerState {
        case loading
        case result(data: ProfileScreenCommentsViewController.View.ViewData)
    }
}
