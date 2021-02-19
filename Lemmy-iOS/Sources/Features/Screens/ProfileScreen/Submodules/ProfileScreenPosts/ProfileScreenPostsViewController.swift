//
//  ProfileScreenPostsViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import SafariServices

protocol ProfileScreenPostViewControllerProtocol: AnyObject {
    func displayProfilePosts(viewModel: ProfileScreenPosts.PostsLoad.ViewModel)
    func displayNextPosts(viewModel: ProfileScreenPosts.NextProfilePostsLoad.ViewModel)
}

class ProfileScreenPostsViewController: UIViewController {
    private let viewModel: ProfileScreenPostsViewModel
    
    weak var coordinator: ProfileScreenCoordinator?
    
    private lazy var tableDataSource = PostsTableDataSource().then {
        $0.delegate = self
    }
    
    private let showMoreHandlerService: ShowMoreHandlerService
    private let contentScoreService: ContentScoreServiceProtocol
    
    lazy var profilePostsView = self.view as! ProfileScreenPostsViewController.View
    
    private var state: ProfileScreenPosts.ViewControllerState
    private var canTriggerPagination = true

    init(
        viewModel: ProfileScreenPostsViewModel,
        initialState: ProfileScreenPosts.ViewControllerState = .loading,
        showMoreHandlerService: ShowMoreHandlerService,
        contentScoreService: ContentScoreServiceProtocol
    ) {
        self.viewModel = viewModel
        self.state = initialState
        self.showMoreHandlerService = showMoreHandlerService
        self.contentScoreService = contentScoreService
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateState(newState: self.state)
    }
    
    override func loadView() {
        let view = ProfileScreenPostsViewController.View(tableViewDelegate: tableDataSource)
        view.delegate = self
        self.view = view
    }
    
    private func updateState(newState: ProfileScreenPosts.ViewControllerState) {
        defer {
            self.state = newState
        }

        if case .loading = newState {
//            self.profilePostsView.showLoadingIndicator()
            return
        }

        if case .loading = self.state {
            self.profilePostsView.hideLoadingIndicator()
        }

        if case .result(let data) = newState {
            if data.posts.isEmpty {
                self.profilePostsView.displayNoData()
            } else {
                self.profilePostsView.updateTableViewData(dataSource: self.tableDataSource)
            }
        }
    }
}

extension ProfileScreenPostsViewController: ProfileScreenPostViewControllerProtocol {    
    func displayProfilePosts(viewModel: ProfileScreenPosts.PostsLoad.ViewModel) {
        guard case let .result(data) = viewModel.state else { return }
        self.tableDataSource.viewModels = data.posts
        self.updateState(newState: viewModel.state)
    }
    
    func displayNextPosts(viewModel: ProfileScreenPosts.NextProfilePostsLoad.ViewModel) {
        guard case let .result(posts) = viewModel.state else { return }
        
        self.tableDataSource.viewModels.append(contentsOf: posts)
        self.profilePostsView.appendNew(data: posts)
        
        if posts.isEmpty {
            self.canTriggerPagination = false
        } else {
            self.canTriggerPagination = true
        }
    }
}

extension ProfileScreenPostsViewController: ProfileScreenPostsViewDelegate {
    func profileScreenPosts(_ view: View, didPickedNewSort type: LMModels.Others.SortType) {
        self.profilePostsView.deleteAllContent()
        self.profilePostsView.showLoadingIndicator()
        self.viewModel.doPostFetch(request: .init(sortType: profilePostsView.sortType))
    }
    
    func profileScreenPostsViewDidPickerTapped(toVc: UIViewController) {
        self.present(toVc, animated: true)
    }
}

extension ProfileScreenPostsViewController: PostsTableDataSourceDelegate {
    func postCellDidSelected(postId: LMModels.Views.PostView.ID) {
        let post = tableDataSource.viewModels.getElement(by: postId).require()
        self.coordinator?.goToPostScreen(post: post)
    }
            
    func voteContent(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        newVote: LemmyVoteType,
        post: LMModels.Views.PostView
    ) {
        guard let coordinator = coordinator else { return }
        
        ContinueIfLogined(on: self, coordinator: coordinator) {
            self.contentScoreService.votePost(scoreView: scoreView,
                                              voteButton: voteButton,
                                              for: newVote,
                                              post: post) { (post) in
                
                self.tableDataSource.viewModels.updateElementById(post)   
            }
        }
    }
    
    func showMore(in post: LMModels.Views.PostView) {
        if let post = self.tableDataSource.viewModels.getElement(by: post.id) {
            guard let coordinator = coordinator else { return }
            self.showMoreHandlerService.showMoreInPost(on: self, coordinator: coordinator, post: post) { updatedPost in
                self.tableDataSource.viewModels.updateElementById(updatedPost)
            }
        }
    }
    
    func usernameTapped(with mention: LemmyUserMention) {
        self.coordinator?.goToProfileScreen(userId: mention.absoluteId, username: mention.absoluteUsername)
    }
    
    func communityTapped(with mention: LemmyCommunityMention) {
        self.coordinator?.goToCommunityScreen(communityId: mention.absoluteId, communityName: mention.absoluteName)
    }

    func onLinkTap(in post: LMModels.Views.PostView, url: URL) {
        self.coordinator?.goToBrowser(with: url)
    }
    
    func tableDidRequestPagination(_ tableDataSource: PostsTableDataSource) {
        guard self.canTriggerPagination else { return }
        
        self.canTriggerPagination = false
        self.viewModel.doNextPostsFetch(request: .init(sortType: profilePostsView.sortType))
    }
    
    func tableDidSelect(post: LMModels.Views.PostView) {
        self.coordinator?.goToPostScreen(post: post)
    }
}
