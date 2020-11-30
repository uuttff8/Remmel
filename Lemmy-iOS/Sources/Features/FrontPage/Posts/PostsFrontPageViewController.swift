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
    
    let model = PostsFrontPageModel()
    
    lazy var tableView = LemmyTableView(style: .plain).then {
        $0.delegate = self
        $0.registerClass(PostContentTableCell.self)
        $0.keyboardDismissMode = .onDrag
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
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.showActivityIndicator()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableHeaderView()
        
        model.loadPosts()
        
        model.dataLoaded = { [self] newPosts in
            addFirstRows(with: newPosts)
            tableView.hideActivityIndicator()
        }
        
        model.newDataLoaded = { [self] newPosts in
            addRows(with: newPosts)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.layoutTableHeaderView()
    }
    
    func addRows(with list: [LemmyModel.PostView], animate: Bool = true) {
        snapshot.insertItems(list, afterItem: model.postsDataSource.last!)
        self.model.postsDataSource.append(contentsOf: list)
        DispatchQueue.main.async { [self] in
            dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
    func addFirstRows(with list: [LemmyModel.PostView], animate: Bool = true) {
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(list, toSection: .posts)
        DispatchQueue.main.async { [self] in
            dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
    fileprivate func setupTableHeaderView() {
        
        pickerView.sortTypeView.addTap {
            self.present(self.pickerView.sortTypeView.configuredAlert, animated: true)
        }
        
        pickerView.listingTypeView.addTap {
            self.present(self.pickerView.listingTypeView.configuredAlert, animated: true)
        }
        
        pickerView.listingTypeView.newCasePicked = { [self] pickedValue in
            self.model.currentFeedType = pickedValue.toInitiallyListing
            
            snapshot.deleteAllItems()
            DispatchQueue.main.async {
                dataSource.apply(snapshot)
            }
            
            model.loadPosts()
        }
        
        pickerView.sortTypeView.newCasePicked = { [self] pickedValue in
            self.model.currentSortType = pickedValue
            
            snapshot.deleteAllItems()
            DispatchQueue.main.async {
                dataSource.apply(snapshot)
            }

            model.loadPosts()
        }
    }
    
    private func makeDataSource() -> UITableViewDiffableDataSource<Section, LemmyModel.PostView> {
        return UITableViewDiffableDataSource<Section, LemmyModel.PostView>(
            tableView: tableView,
            cellProvider: { (tableView, indexPath, _) -> UITableViewCell? in
                let cell = tableView.cell(forClass: PostContentTableCell.self)
                cell.postContentView.delegate = self
                cell.bind(with: self.model.postsDataSource[indexPath.row], config: .default)
                return cell
            })
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
            make.edges.equalToSuperview()
        }
    }
}

extension PostsFrontPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleDidSelectForPosts(indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let indexPathRow = indexPath.row
        let bottomItems = self.model.postsDataSource.count - 5

        if indexPathRow >= bottomItems {
            guard !model.isFetchingNewContent else { return }

            model.isFetchingNewContent = true
            model.currentPage += 1
            model.loadMorePosts {
                self.model.isFetchingNewContent = false
            }
        }
    }

    private func handleDidSelectForPosts(indexPath: IndexPath) {
        let post = model.postsDataSource[indexPath.row]
        coordinator?.goToPostScreen(post: post)
    }
}

extension PostsFrontPageViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PostsFrontPageViewController: PostContentTableCellDelegate {
    func upvote(voteButton: VoteButton, newVote: LemmyVoteType, post: LemmyModel.PostView) {
        vote(voteButton: voteButton, for: newVote, post: post)
    }
    
    func downvote(voteButton: VoteButton, newVote: LemmyVoteType, post: LemmyModel.PostView) {
        vote(voteButton: voteButton, for: newVote, post: post)
    }
    
    func onLinkTap(in post: LemmyModel.PostView, url: URL) {
        let vc = SFSafariViewController(url: url)
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    func usernameTapped(in post: LemmyModel.PostView) {
        coordinator?.goToProfileScreen(by: post.creatorId)
    }
    
    func communityTapped(in post: LemmyModel.PostView) {
        coordinator?.goToCommunityScreen(communityId: post.communityId)
    }
    
    private func vote(voteButton: VoteButton, for newVote: LemmyVoteType, post: LemmyModel.PostView) {
        guard let coordinator = coordinator else { return }
        
        ContinueIfLogined(on: self, coordinator: coordinator) {
            voteButton.setVoted(to: newVote)
            model.createPostLike(newVote: newVote, post: post)
        }
    }
}
