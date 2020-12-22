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

    let model = CommentsFrontPageModel()

    lazy var tableView = LemmyTableView(style: .plain).then {
        $0.registerClass(CommentContentTableCell.self)
        $0.delegate = model
        $0.keyboardDismissMode = .onDrag
    }
    
    private let showMoreHandler = ShowMoreHandlerService()
    
    private lazy var dataSource = makeDataSource()
    private var snapshot = NSDiffableDataSourceSnapshot<Section, LemmyModel.CommentView>()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(tableView)

        model.loadComments()

        model.dataLoaded = { [self] newComments in
            addFirstRows(with: newComments)
        }

        model.newDataLoaded = { [self] newComments in
            addRows(with: newComments)
        }        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        tableView.layoutTableHeaderView()
    }

    func addRows(with list: [LemmyModel.CommentView], animate: Bool = true) {
        snapshot.insertItems(list, afterItem: model.commentsDataSource.last!)
        self.model.commentsDataSource.append(contentsOf: list)
        DispatchQueue.main.async { [self] in
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }

    func addFirstRows(with list: [LemmyModel.CommentView], animate: Bool = true) {
        snapshot.appendSections([.main])
        snapshot.appendItems(list)
        DispatchQueue.main.async { [self] in
            dataSource.apply(snapshot, animatingDifferences: false)
        }
    }

    private func makeDataSource() -> UITableViewDiffableDataSource<Section, LemmyModel.CommentView> {
        return UITableViewDiffableDataSource<Section, LemmyModel.CommentView>(
            tableView: tableView,
            cellProvider: { (tableView, indexPath, _) -> UITableViewCell? in
                let cell = tableView.cell(forClass: CommentContentTableCell.self)
                cell.commentContentView.delegate = self
                cell.bind(with: self.model.commentsDataSource[indexPath.row], level: 0)

                return cell
        })
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
    
    func upvote(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        newVote: LemmyVoteType,
        comment: LemmyModel.CommentView
    ) {
        vote(scoreView: scoreView, voteButton: voteButton, newVote: newVote, comment: comment)
    }
    
    func downvote(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        newVote: LemmyVoteType,
        comment: LemmyModel.CommentView
    ) {
        vote(scoreView: scoreView, voteButton: voteButton, newVote: newVote, comment: comment)
    }
    
    // TODO: add implementation
    func showContext(in comment: LemmyModel.CommentView) { }
    
    func reply(to comment: LemmyModel.CommentView) {
        coordinator?.goToWriteComment(postId: comment.postId, parrentComment: comment)
    }
    
    func onLinkTap(in comment: LemmyModel.CommentView, url: URL) {
        self.coordinator?.goToBrowser(with: url)
    }
    
    func showMoreAction(in comment: LemmyModel.CommentView) {
        showMoreHandler.showMoreInComment(on: self, comment: comment)
    }
    
    private func vote(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        newVote: LemmyVoteType,
        comment: LemmyModel.CommentView
    ) {
        guard let coordinator = coordinator else { return }
        
        ContinueIfLogined(on: self, coordinator: coordinator) {
            scoreView.setVoted(voteButton: voteButton, to: newVote)
            model.createCommentLike(newVote: newVote, comment: comment)
        }
    }
}
