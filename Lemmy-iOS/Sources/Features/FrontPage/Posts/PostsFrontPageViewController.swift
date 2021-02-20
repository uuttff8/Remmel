//
//  PostsFrontPageViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import SafariServices

extension PostsFrontPageViewController {
    struct Appearance {
        let estimatedRowHeight: CGFloat = PostContentPreviewTableCell.estimatedHeight
    }
}

class PostsFrontPageViewController: UIViewController {
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, LMModels.Views.PostView>
    
    enum Section: Hashable, CaseIterable {
        case posts
    }
    
    weak var coordinator: FrontPageCoordinator?    
    
    private let appearance: Appearance
    
    let viewModel = PostsFrontPageModel()
    let showMoreHandler = ShowMoreHandlerService()
    
    let refreshControl = UIRefreshControl()
    
    lazy var tableView = LemmyTableView(style: .plain).then {
        $0.delegate = self
        $0.registerClass(PostContentPreviewTableCell.self)
        $0.keyboardDismissMode = .onDrag
        $0.refreshControl = self.refreshControl
        self.refreshControl.addTarget(self, action: #selector(self.refreshControlValueChanged), for: .valueChanged)
    }
    
    private lazy var dataSource = makeDataSource()
    
    let pickerView = LemmySortListingPickersView()
    
    init(appearance: Appearance = Appearance()) {
        self.appearance = appearance
        super.init(nibName: nil, bundle: nil)
        
        setupView()
        addSubviews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.showActivityIndicator()
        viewModel.loadPosts()
        setupTableHeaderView()
        
        viewModel.dataLoaded = { [self] in
            diffTable(animating: false)
            tableView.hideActivityIndicator()
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
        
        viewModel.newDataLoaded = { [self] in
            diffTable(animating: true)
        }
        
        viewModel.createPostLikeUpdate = { index in
            let indexPath = IndexPath(row: index, section: 0)
            
            if let cell = self.tableView.cellForRow(at: indexPath) as? PostContentPreviewTableCell {
                cell.updateForCreatePostLike(post: self.viewModel.postsDataSource[index])
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.receiveMessages()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.layoutTableHeaderView()
    }
    
    @objc func refreshControlValueChanged() {
        updateTableData(immediately: false)
    }
        
    func diffTable(animating: Bool) {
        var snapshot = Snapshot()
        
        snapshot.appendSections([.posts])
        snapshot.appendItems(self.viewModel.postsDataSource, toSection: .posts)
        dataSource.apply(snapshot, animatingDifferences: animating)
    }
    
    fileprivate func setupTableHeaderView() {
        pickerView.listingFirstPick = viewModel.currentListingType
        pickerView.sortFirstPick = viewModel.currentSortType
        
        pickerView.sortTypeView.addTap {
            self.present(self.pickerView.sortTypeView.configuredAlert, animated: true)
        }
        
        pickerView.listingTypeView.addTap {
            self.present(self.pickerView.listingTypeView.configuredAlert, animated: true)
        }
                
        pickerView.listingTypeView.newCasePicked = { [self] pickedValue in
            self.viewModel.currentListingType = pickedValue
            
            updateTableData(immediately: true)
        }
        
        pickerView.sortTypeView.newCasePicked = { [self] pickedValue in
            self.viewModel.currentSortType = pickedValue
            
            updateTableData(immediately: true)
        }
    }
    
    private func makeDataSource() -> UITableViewDiffableDataSource<Section, LMModels.Views.PostView> {
        return UITableViewDiffableDataSource<Section, LMModels.Views.PostView>(
            tableView: tableView,
            cellProvider: { (tableView, indexPath, _) -> UITableViewCell? in
                let cell = tableView.cell(forClass: PostContentPreviewTableCell.self)
                cell.postContentView.delegate = self
                cell.bind(with: self.viewModel.postsDataSource[indexPath.row], isInsideCommunity: false)
                return cell
            })
    }
    
    private func updateTableData(immediately: Bool) {
        if immediately {
            let snapshot = Snapshot()
            self.dataSource.apply(snapshot)
        }

        viewModel.loadPosts()
    }
}

extension PostsFrontPageViewController: ProgrammaticallyViewProtocol {
    func setupView() {
        tableView.tableHeaderView = pickerView
        tableView.estimatedRowHeight = self.appearance.estimatedRowHeight
    }
    
    func addSubviews() {
        self.view.addSubview(tableView)
    }
    
    func makeConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

extension PostsFrontPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let indexPathRow = indexPath.row
        let bottomItems = self.viewModel.postsDataSource.count - 5

        if indexPathRow >= bottomItems {
            guard !viewModel.isFetchingNewContent else { return }

            viewModel.isFetchingNewContent = true
            viewModel.currentPage += 1
            viewModel.loadMorePosts {
                self.viewModel.isFetchingNewContent = false
            }
        }
    }

    private func handleDidSelectForPosts(indexPath: IndexPath) {
        let post = viewModel.postsDataSource[indexPath.row]
        coordinator?.goToPostScreen(post: post)
    }
}

extension PostsFrontPageViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PostsFrontPageViewController: PostContentPreviewTableCellDelegate {
    func postCellDidSelected(postId: LMModels.Views.PostView.ID) {
        let post = viewModel.postsDataSource.getElement(by: postId).require()
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
            scoreView.setVoted(voteButton: voteButton, to: newVote)
            viewModel.createPostLike(newVote: newVote, post: post)
        }
    }
    
    func usernameTapped(with mention: LemmyUserMention) {
        self.coordinator?.goToProfileScreen(userId: mention.absoluteId, username: mention.absoluteUsername)
    }
    
    func communityTapped(with mention: LemmyCommunityMention) {
        self.coordinator?.goToCommunityScreen(communityId: mention.absoluteId, communityName: mention.absoluteName)
    }

    func showMore(in post: LMModels.Views.PostView) {
        
        if let post = self.viewModel.postsDataSource.getElement(by: post.id) {
            guard let coordinator = coordinator else { return }
            showMoreHandler.showMoreInPost(on: self, coordinator: coordinator, post: post) { updatedPost in
                self.viewModel.postsDataSource.updateElementById(updatedPost)
            }
        }
    }
}
