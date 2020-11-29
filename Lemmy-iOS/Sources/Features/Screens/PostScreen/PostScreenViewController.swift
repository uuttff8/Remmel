//
//  PostScreenViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/26/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import SafariServices

protocol PostScreenViewControllerProtocol: AnyObject {
    func displayPost(response: PostScreen.PostLoad.ViewModel)
}

class PostScreenViewController: UIViewController, Containered {
    weak var coordinator: PostScreenCoordinator?
    private let viewModel: PostScreenViewModelProtocol
        
    lazy var postScreenView = PostScreenViewController.View().then {
        $0.headerView.postHeaderView.delegate = self
    }
    
    let foldableCommentsViewController = FoldableLemmyCommentsViewController()
    
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

        postScreenView.presentOnVc = { toPresentVc in
            self.present(toPresentVc, animated: true)
        }

        postScreenView.dismissOnVc = {
            self.dismiss(animated: true)
        }
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
        let safariVc = SFSafariViewController(url: url)
        safariVc.delegate = self
        present(safariVc, animated: true)
    }
    
    private func vote(voteButton: VoteButton, for newVote: LemmyVoteType, post: LemmyModel.PostView) {
        guard let coordinator = coordinator else { return }
        
        ContinueIfLogined(on: self, coordinator: coordinator) {
            voteButton.setVoted(to: newVote)
            viewModel.doPostLike(newVote: newVote, post: post)
        }
    }
}

extension PostScreenViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.dismiss(animated: true)
    }
}
