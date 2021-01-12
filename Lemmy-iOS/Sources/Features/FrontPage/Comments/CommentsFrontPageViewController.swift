//
//  CommentsFrontPageViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CommentsFrontPageViewController: UIViewController {

    enum Section {
        case main
    }

    weak var coordinator: FrontPageCoordinator?

    let viewModel = CommentsFrontPageModel()
    
    let refreshControl = UIRefreshControl()

    lazy var tableView = LemmyTableView(style: .plain).then {
        $0.registerClass(CommentContentTableCell.self)
        $0.delegate = viewModel
        $0.keyboardDismissMode = .onDrag
        $0.refreshControl = self.refreshControl
        self.refreshControl.addTarget(self, action: #selector(refreshControlValueChanged), for: .valueChanged)
    }
    
    private let showMoreHandler = ShowMoreHandlerService()
    
    private lazy var dataSource = makeDataSource()
    private var snapshot = NSDiffableDataSourceSnapshot<Section, LemmyModel.CommentView>()
    
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
        viewModel.loadComments()
        setupTableHeaderView()

        viewModel.dataLoaded = { [self] newComments in
            addFirstRows(with: newComments)
            tableView.hideActivityIndicator()
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }

        viewModel.newDataLoaded = { [self] newComments in
            addRows(with: newComments)
        }        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.showActivityIndicator()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        tableView.layoutTableHeaderView()
    }

    func addRows(with list: [LemmyModel.CommentView], animate: Bool = true) {
        guard !list.isEmpty else { return }

        snapshot.insertItems(list, afterItem: viewModel.commentsDataSource.last!)
        self.viewModel.commentsDataSource.append(contentsOf: list)
        DispatchQueue.main.async { [self] in
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }

    func addFirstRows(with list: [LemmyModel.CommentView], animate: Bool = true) {
        self.tableView.hideActivityIndicator()
        self.snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(list)
        DispatchQueue.main.async { [self] in
            dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
    @objc func refreshControlValueChanged() {
        updateTableData(immediately: false)
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

    private func makeDataSource() -> UITableViewDiffableDataSource<Section, LemmyModel.CommentView> {
        return UITableViewDiffableDataSource<Section, LemmyModel.CommentView>(
            tableView: tableView,
            cellProvider: { (tableView, indexPath, _) -> UITableViewCell? in
                let cell = tableView.cell(forClass: CommentContentTableCell.self)
                cell.commentContentView.delegate = self
                cell.bind(with: self.viewModel.commentsDataSource[indexPath.row], level: 0)

                return cell
        })
    }
    
    private func updateTableData(immediately: Bool) {
        if immediately { snapshot.deleteAllItems() }
        DispatchQueue.main.async {
            self.dataSource.apply(self.snapshot)
        }

        viewModel.loadComments()
    }
}

extension CommentsFrontPageViewController: CommentContentTableCellDelegate {
    func onMentionTap(in post: LemmyModel.CommentView, mention: LemmyMention) {
        self.coordinator?.goToProfileScreen(by: mention.absoluteUsername)
    }
    
    func onMentionTap(in post: LemmyModel.PostView, mention: LemmyMention) {
        self.coordinator?.goToProfileScreen(by: mention.absoluteUsername)
    }
    
    func postNameTapped(in comment: LemmyModel.CommentView) {
        self.coordinator?.goToPostScreen(postId: comment.postId)
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
            scoreView.setVoted(voteButton: voteButton, to: newVote)
            viewModel.createCommentLike(newVote: newVote, comment: comment)
        }
    }
    
    func showContext(in comment: LemmyModel.CommentView) {
        self.coordinator?.goToPostAndScroll(to: comment)
    }
    
    func reply(to comment: LemmyModel.CommentView) {
        coordinator?.goToWriteComment(postId: comment.postId, parrentComment: comment)
    }
    
    func onLinkTap(in comment: LemmyModel.CommentView, url: URL) {
        self.coordinator?.goToBrowser(with: url)
    }
    
    func showMoreAction(in comment: LemmyModel.CommentView) {
        guard let coordinator = coordinator else { return }
        showMoreHandler.showMoreInComment(on: self, coordinator: coordinator, comment: comment)
    }    
}

extension CommentsFrontPageViewController: ProgrammaticallyViewProtocol {
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
