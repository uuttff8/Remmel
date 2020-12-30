//
//  PostScreenViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/26/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol PostScreenViewControllerProtocol: AnyObject {
    func displayPost(viewModel: PostScreen.PostLoad.ViewModel)
    func operateSaveNewComment(viewModel: PostScreen.SaveComment.ViewModel)
    func operateSaveNewPost(viewModel: PostScreen.SavePost.ViewModel)
}

class PostScreenViewController: UIViewController, Containered {
    weak var coordinator: PostScreenCoordinator?
    private let viewModel: PostScreenViewModelProtocol
        
    private let showMoreHandlerService = ShowMoreHandlerService()
    lazy var postScreenView = PostScreenViewController.View().then {
        $0.headerView.postHeaderView.delegate = self
        $0.delegate = self
    }
    
    private lazy var commentsViewController = FoldableLemmyCommentsViewController().then {
        $0.commentDelegate = self
    }
    
    private var state: PostScreen.ViewControllerState
    
    private let scrollToComment: LemmyModel.CommentView?

    init(
        viewModel: PostScreenViewModelProtocol,
        state: PostScreen.ViewControllerState = .loading,
        scrollToComment: LemmyModel.CommentView?
    ) {
        self.viewModel = viewModel
        self.state = state
        self.scrollToComment = scrollToComment
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.add(asChildViewController: commentsViewController)
        
        viewModel.doPostFetch()
        self.updateState(newState: state)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        self.coordinator?.removeDependency(coordinator)
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
            self.state = .result(data: data)
            self.postScreenView.bind(with: data.post)
            self.commentsViewController.showComments(with: data.comments)
            self.commentsViewController.setupHeaderView(postScreenView)
            
            if let comment = self.scrollToComment {
                self.commentsViewController.scrollTo(comment)
            }
        }
    }
}

extension PostScreenViewController: PostScreenViewControllerProtocol {
    func displayPost(viewModel: PostScreen.PostLoad.ViewModel) {
        self.updateState(newState: viewModel.state)
    }
        
    func operateSaveNewComment(viewModel: PostScreen.SaveComment.ViewModel) {
        commentsViewController.saveNewComment(comment: viewModel.comment)
    }

    func operateSaveNewPost(viewModel: PostScreen.SavePost.ViewModel) {
        self.postScreenView.bind(with: viewModel.post)
    }
}

extension PostScreenViewController: PostContentTableCellDelegate {
    func postCellDidSelected(postId: LemmyModel.PostView.ID) {
        let post = postScreenView.postData.require()
        self.coordinator?.goToPostScreen(post: post)
    }
    
    func onMentionTap(in post: LemmyModel.PostView, mention: LemmyMention) {
        self.coordinator?.goToProfileScreen(by: mention.absoluteUsername)
    }
    
    func voteContent(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        newVote: LemmyVoteType,
        post: LemmyModel.PostView
    ) {
        guard let coordinator = coordinator else { return }
        
        ContinueIfLogined(on: self, coordinator: coordinator) {
            viewModel.doPostLike(scoreView: scoreView, voteButton: voteButton, for: newVote, post: post)
        }
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
}

extension PostScreenViewController: CommentsViewControllerDelegate {
    func onMentionTap(in post: LemmyModel.CommentView, mention: LemmyMention) {
        self.coordinator?.goToProfileScreen(by: mention.absoluteUsername)
    }
    
    func postNameTapped(in comment: LemmyModel.CommentView) {
        // not using
    }
    
    func usernameTapped(in comment: LemmyModel.CommentView) {
        self.coordinator?.goToProfileScreen(by: comment.creatorId)
    }
    
    func communityTapped(in comment: LemmyModel.CommentView) {
        self.coordinator?.goToCommunityScreen(communityId: comment.communityId)
    }
        
    func voteContent(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        newVote: LemmyVoteType,
        comment: LemmyModel.CommentView
    ) {
        guard let coordinator = coordinator else { return }
        
        ContinueIfLogined(on: self, coordinator: coordinator) {
            self.viewModel.doCommentLike(scoreView: scoreView, voteButton: voteButton, for: newVote, comment: comment)
        }
    }
        
    func showContext(in comment: LemmyModel.CommentView) { }
    
    func reply(to comment: LemmyModel.CommentView) {
        coordinator?.goToWriteComment(postId: comment.postId, parrentComment: comment)
    }
    
    func onLinkTap(in comment: LemmyModel.CommentView, url: URL) {
        self.coordinator?.goToBrowser(with: url)
    }
    
    func showMoreAction(in comment: LemmyModel.CommentView) {
        showMoreHandlerService.showMoreInComment(on: self, comment: comment)
    }
}

extension PostScreenViewController: PostScreenViewDelegate {
    func postView(_ postView: View, didWriteCommentTappedWith post: LemmyModel.PostView) {
        self.coordinator?.goToWriteComment(postId: post.id, parrentComment: nil)
    }
    
    func postView(didEmbedTappedWith url: URL) {
        self.coordinator?.goToBrowser(with: url)
    }
}
