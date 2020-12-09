//
//  PostScreenViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/26/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol PostScreenViewControllerProtocol: AnyObject {
    func displayPost(response: PostScreen.PostLoad.ViewModel)
}

class PostScreenViewController: UIViewController, Containered {
    weak var coordinator: PostScreenCoordinator?
    private let viewModel: PostScreenViewModelProtocol
        
    private let showMoreHandlerService = ShowMoreHandlerService()
    lazy var postScreenView = PostScreenViewController.View().then {
        $0.headerView.postHeaderView.delegate = self
        $0.delegate = self
    }
    
    private lazy var foldableCommentsViewController = FoldableLemmyCommentsViewController().then {
        $0.commentDelegate = self
    }
    
    private var state: PostScreen.ViewControllerState

    init(
        viewModel: PostScreenViewModelProtocol,
        state: PostScreen.ViewControllerState = .loading
    ) {
        self.viewModel = viewModel
        self.state = state
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.add(asChildViewController: foldableCommentsViewController)
        
        viewModel.doPostFetch()
        self.updateState(newState: state)
    }
        
    private func updateState(newState: PostScreen.ViewControllerState) {
        defer {
            self.state = newState
        }

        if case .loading = newState {
            self.postScreenView.showLoadingView()
            return
        }

        if case .loading = self.state {
            self.postScreenView.hideLoadingView()
        }

        if case .result(let data) = newState {
            self.postScreenView.bind(with: data.post)
            self.foldableCommentsViewController.showComments(with: data.comments)
            self.foldableCommentsViewController.setupHeaderView(postScreenView)
        }
    }
}

extension PostScreenViewController: PostScreenViewControllerProtocol {
    func displayPost(response: PostScreen.PostLoad.ViewModel) {
//        guard case let .result(data) = response.state else { return }
                
//        self.tableDataSource.viewModels = data.comments
        self.updateState(newState: response.state)
    }
}

extension PostScreenViewController: PostContentTableCellDelegate {
    func upvote(voteButton: VoteButton, newVote: LemmyVoteType, post: LemmyModel.PostView) {
        vote(voteButton: voteButton, for: newVote, post: post)
    }
    
    func downvote(voteButton: VoteButton, newVote: LemmyVoteType, post: LemmyModel.PostView) {
        vote(voteButton: voteButton, for: newVote, post: post)
    }
    
    func usernameTapped(in post: LemmyModel.PostView) {
        coordinator?.goToProfileScreen(by: post.creatorId)
    }
    
    func communityTapped(in post: LemmyModel.PostView) {
        coordinator?.goToCommunityScreen(communityId: post.communityId)
    }
    
    func onLinkTap(in post: LemmyModel.PostView, url: URL) {
        coordinator?.goToBrowser(with: url)
    }
    
    func showMore(in post: LemmyModel.PostView) {
        self.showMoreHandlerService.showMoreInPost(on: self, post: post)
    }
    
    private func vote(voteButton: VoteButton, for newVote: LemmyVoteType, post: LemmyModel.PostView) {
        guard let coordinator = coordinator else { return }
        
        ContinueIfLogined(on: self, coordinator: coordinator) {
            viewModel.doPostLike(voteButton: voteButton, for: newVote, post: post)
        }
    }
}

extension PostScreenViewController: CommentsViewControllerDelegate {
    func postNameTapped(in comment: LemmyModel.CommentView) {
        // not using
    }
    
    func usernameTapped(in comment: LemmyModel.CommentView) {
        self.coordinator?.goToProfileScreen(by: comment.creatorId)
    }
    
    func communityTapped(in comment: LemmyModel.CommentView) {
        self.coordinator?.goToCommunityScreen(communityId: comment.communityId)
    }
    
    func upvote(voteButton: VoteButton, newVote: LemmyVoteType, comment: LemmyModel.CommentView) {
        guard let coordinator = coordinator else { return }
        
        ContinueIfLogined(on: self, coordinator: coordinator) {
//            let type = voteButton.viewData?.voteType == .up ? .none : LemmyVoteType.up
//            voteButton.viewData?.voteType = type
            
            voteButton.setVoted(to: newVote)
        }
    }
    
    func downvote(voteButton: VoteButton, newVote: LemmyVoteType, comment: LemmyModel.CommentView) {
        guard let coordinator = coordinator else { return }
        
        ContinueIfLogined(on: self, coordinator: coordinator) {
//            let type = voteButton.viewData?.voteType == .down ? .none : LemmyVoteType.down
//            voteButton.viewData?.voteType = type
            
            voteButton.setVoted(to: newVote)
        }
    }
        
    func showContext(in comment: LemmyModel.CommentView) {
        print("show context in \(comment.id)")
    }
    
    func reply(to comment: LemmyModel.CommentView) {
        print("reply to \(comment.id)")
    }
    
    func onLinkTap(in comment: LemmyModel.CommentView, url: URL) {
        self.coordinator?.goToBrowser(with: url)
    }
    
    func showMoreAction(in comment: LemmyModel.CommentView) {
        showMoreHandlerService.showMoreInComment(on: self, comment: comment)
    }
}

extension PostScreenViewController: PostScreenViewDelegate {
    func postView(didEmbedTappedWith url: URL) {
        self.coordinator?.goToBrowser(with: url)
    }
}
