//
//  CommentContentTableCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/13/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Nuke

protocol CommentContentTableCellDelegate: AnyObject {
    func usernameTapped(with mention: LemmyUserMention)
    func communityTapped(with mention: LemmyCommunityMention)
    func postNameTapped(in comment: LMModels.Views.CommentView)
    func voteContent(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        newVote: LemmyVoteType,
        comment: LMModels.Views.CommentView
    )
    func showContext(in comment: LMModels.Views.CommentView)
    func reply(to comment: LMModels.Views.CommentView)
    func onLinkTap(in comment: LMModels.Views.CommentView, url: URL)
    func showMoreAction(in comment: LMModels.Views.CommentView)
    func presentVc(viewController: UIViewController)
}

extension CommentContentTableCellDelegate where Self: UIViewController {
    func presentVc(viewController: UIViewController) {
        self.present(viewController, animated: true)
    }
}

extension CommentContentTableCell {
    struct Appearance {
        
        var config: CommentContentView.Setting = CommentContentView.Setting.list
        
        let backgroundColor = UIColor.systemBackground
    }
}

// MARK: - CommentContentTableCell: CommentCell
class CommentContentTableCell: UITableViewCell, ContentFocusable {

    static let estimatedHeight: CGFloat = 220
    
    var appearance = Appearance()
    
    // MARK: - Properties
    let commentContentView = CommentContentView()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        addSubviews()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public API
    func bind(with comment: LMModels.Views.CommentView, level: Int, appearance: Appearance = Appearance()) {
        self.appearance = appearance
        
        commentContentView.bind(with: comment, setting: appearance.config)
    }
    
    func updateForCreateCommentLike(comment: LMModels.Views.CommentView) {
        commentContentView.updateForCreateCommentLike(comment: comment)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.isHidden = false
        self.isSelected = false
        self.isHighlighted = false
        self.commentContentView.prepareForReuse()
    }
}

extension CommentContentTableCell: ProgrammaticallyViewProtocol {
    func setupView() {
        self.selectionStyle = .none
        
        // comment cell
        self.backgroundColor = appearance.backgroundColor
    }
    
    func addSubviews() {
        self.contentView.addSubview(commentContentView)
    }
    
    func makeConstraints() {
        self.commentContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
