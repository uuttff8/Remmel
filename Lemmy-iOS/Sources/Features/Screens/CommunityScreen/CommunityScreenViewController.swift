//
//  CommunityScreen.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 01.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

protocol CommunityScreenViewControllerProtocol: AnyObject {
    func displayCommunityHeader(viewModel: CommunityScreen.CommunityHeaderLoad.ViewModel)
    func displayPosts(viewModel: CommunityScreen.CommunityPostsLoad.ViewModel)
    func displayNextPosts(viewModel: CommunityScreen.NextCommunityPostsLoad.ViewModel)
}

class CommunityScreenViewController: UIViewController {
    
    weak var coordinator: CommunityScreenCoordinator?
    
    private let viewModel: CommunityScreenViewModelProtocol
    private lazy var tableDataSource = CommunityScreenTableDataSource().then {
        $0.delegate = self
    }

    lazy var communityView = self.view as! CommunityScreenViewController.View
    
    private var canTriggerPagination = true
    private var state: CommunityScreen.ViewControllerState
    private let followService: CommunityFollowServiceProtocol
    private let contentScoreService: ContentScoreServiceProtocol
    private let showMoreService: ShowMoreHandlerServiceProtocol
    
    private var cancellable = Set<AnyCancellable>()
    
    init(
        viewModel: CommunityScreenViewModelProtocol,
        state: CommunityScreen.ViewControllerState = .loading,
        followService: CommunityFollowServiceProtocol,
        contentScoreService: ContentScoreServiceProtocol,
        showMoreService: ShowMoreHandlerServiceProtocol
    ) {
        self.viewModel = viewModel
        self.state = state
        self.followService = followService
        self.contentScoreService = contentScoreService
        self.showMoreService = showMoreService
        super.init(nibName: nil, bundle: nil)
    }    
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = CommunityScreenViewController.View(tableViewDelegate: tableDataSource)
        view.delegate = self
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.doCommunityFetch()
        viewModel.doPostsFetch(request: .init(contentType: communityView.contentType))
        self.updateState(newState: state)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.removeDependency(coordinator)
    }
    
    private func updateState(newState: CommunityScreen.ViewControllerState) {
        defer {
            self.state = newState
        }

        if case .loading = newState {
            self.communityView.showLoadingView()
            return
        }

        if case .loading = self.state {
            self.communityView.hideLoadingView()
        }

        if case .result = newState {
            self.communityView.updateTableViewData(dataSource: self.tableDataSource)
        }
    }
    
    private func updatePagination(hasNextPage: Bool, hasError: Bool) {
        self.canTriggerPagination = hasNextPage
    }
}

extension CommunityScreenViewController: CommunityScreenViewControllerProtocol {
    func displayCommunityHeader(viewModel: CommunityScreen.CommunityHeaderLoad.ViewModel) {
        self.communityView.communityHeaderViewData = viewModel.data.community
        self.title = viewModel.data.community.name
    }
    
    func displayPosts(viewModel: CommunityScreen.CommunityPostsLoad.ViewModel) {
        guard case let .result(data) = viewModel.state else { return }
        self.tableDataSource.viewModels = data
        self.updateState(newState: viewModel.state)
    }
    
    func displayNextPosts(viewModel: CommunityScreen.NextCommunityPostsLoad.ViewModel) {
        switch viewModel.state {
        case .result(let posts):
            self.tableDataSource.viewModels.append(contentsOf: posts)
            self.communityView.appendNew(data: posts)
            
            if posts.isEmpty {
                self.updatePagination(hasNextPage: false, hasError: false)
            } else {
                self.updatePagination(hasNextPage: true, hasError: false)
            }
        case .error:
            break
        }
    }
}

extension CommunityScreenViewController: CommunityScreenViewDelegate {
    func headerViewDidTapped(followButton: FollowButton, in community: LemmyModel.CommunityView) {
        self.followService.followUi(followButton: followButton, to: community)
            .sink { (community) in
                self.communityView.communityHeaderViewData = community
            }.store(in: &self.cancellable)
    }
    
    func communityViewDidPickerTapped(_ communityView: View, toVc: UIViewController) {
        self.present(toVc, animated: true)
    }
    
    func communityViewDidReadMoreTapped(_ communityView: View, toVc: MarkdownParsedViewController) {
        self.present(toVc, animated: true)
    }
}

extension CommunityScreenViewController: CommunityScreenTableDataSourceDelegate {
    func tableDidRequestPagination(_ tableDataSource: CommunityScreenTableDataSource) {
        guard self.canTriggerPagination else { return }
        
        self.canTriggerPagination = false
        self.viewModel.doNextPostsFetch(request: .init(contentType: communityView.contentType))
    }    
}

extension CommunityScreenViewController: PostContentPreviewTableCellDelegate {    
    func voteContent(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        newVote: LemmyVoteType,
        post: LemmyModel.PostView
    ) {
        guard let coordinator = coordinator else { return }
        
        ContinueIfLogined(on: self, coordinator: coordinator) {
            self.contentScoreService.votePost(
                scoreView: scoreView,
                voteButton: voteButton,
                for: newVote,
                post: post
            ) { (newPost) in
                self.tableDataSource.viewModels.updateElementById(newPost)
            }
        }
    }
    
    func usernameTapped(in post: LemmyModel.PostView) {
        self.coordinator?.goToProfileScreen(by: post.creatorId)
    }
    
    func communityTapped(in post: LemmyModel.PostView) {
        // not used
    }
    
    func showMore(in post: LemmyModel.PostView) {
        self.showMoreService.showMoreInPost(on: self, post: post)
    }
    
    func postCellDidSelected(postId: LemmyModel.PostView.ID) {
        self.coordinator?.goToPostScreen(postId: postId)
    }
}
