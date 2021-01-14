//
//  PostsFrontPageViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import SafariServices

class PostsFrontPageViewController: UIViewController {
    
    enum Section: Hashable, CaseIterable {
        case posts
    }
    
    weak var coordinator: FrontPageCoordinator?    
    
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
    private var snapshot = NSDiffableDataSourceSnapshot<Section, LemmyModel.PostView>()
    
    let pickerView = LemmySortListingPickersView()
    
    init() {
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
        
        viewModel.dataLoaded = { [self] newPosts in
            addFirstRows(with: newPosts)
            tableView.hideActivityIndicator()
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
        
        viewModel.newDataLoaded = { [self] newPosts in
            addRows(with: newPosts)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.layoutTableHeaderView()
    }
    
    @objc func refreshControlValueChanged() {
        updateTableData(immediately: false)
    }
    
    func addRows(with list: [LemmyModel.PostView], animate: Bool = true) {
        guard !list.isEmpty else { return }
        
        snapshot.insertItems(list, afterItem: viewModel.postsDataSource.last!)
        self.viewModel.postsDataSource.append(contentsOf: list)
        DispatchQueue.main.async { [self] in
            dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
    func addFirstRows(with list: [LemmyModel.PostView], animate: Bool = true) {
        self.tableView.hideActivityIndicator()
        self.snapshot.deleteAllItems()
        self.snapshot.appendSections(Section.allCases)
        self.snapshot.appendItems(list, toSection: .posts)
        DispatchQueue.main.async { [self] in
            dataSource.apply(snapshot, animatingDifferences: false)
        }
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
    
    private func makeDataSource() -> UITableViewDiffableDataSource<Section, LemmyModel.PostView> {
        return UITableViewDiffableDataSource<Section, LemmyModel.PostView>(
            tableView: tableView,
            cellProvider: { (tableView, indexPath, _) -> UITableViewCell? in
                let cell = tableView.cell(forClass: PostContentPreviewTableCell.self)
                cell.postContentView.delegate = self
                cell.bind(with: self.viewModel.postsDataSource[indexPath.row], isInsideCommunity: false)
                return cell
            })
    }
    
    private func updateTableData(immediately: Bool) {
        if immediately { snapshot.deleteAllItems() }
        DispatchQueue.main.async {
            self.dataSource.apply(self.snapshot)
        }

        viewModel.loadPosts()
    }
}

extension PostsFrontPageViewController: ProgrammaticallyViewProtocol {
    func setupView() {
        tableView.tableHeaderView = pickerView
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
    func postCellDidSelected(postId: LemmyModel.PostView.ID) {
        let post = viewModel.getPost(by: postId).require()
        self.coordinator?.goToPostScreen(post: post)
    }
            
    func voteContent(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        newVote: LemmyVoteType,
        post: LemmyModel.PostView
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

    func showMore(in post: LemmyModel.PostView) {
        guard let coordinator = coordinator else { return }
        showMoreHandler.showMoreInPost(on: self, coordinator: coordinator, post: post)
    }    
}
