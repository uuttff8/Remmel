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
    func usernameTapped(in comment: LemmyModel.CommentView)
    func communityTapped(in comment: LemmyModel.CommentView)
    func postNameTapped(in comment: LemmyModel.CommentView)
    func voteContent(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        newVote: LemmyVoteType,
        comment: LemmyModel.CommentView
    )
    func showContext(in comment: LemmyModel.CommentView)
    func reply(to comment: LemmyModel.CommentView)
    func onLinkTap(in comment: LemmyModel.CommentView, url: URL)
    func onMentionTap(in post: LemmyModel.CommentView, mention: LemmyMention)
    func showMoreAction(in comment: LemmyModel.CommentView)
}

extension CommentContentTableCell {
    struct Appearance {
        
        var config: CommentContentView.Setting = CommentContentView.Setting.list
        
        let rootCommentMarginColor = UIColor.systemBackground
        let commentMarginColor = UIColor.systemBackground
        let backgroundColor = UIColor.systemBackground
        
        let indentColors = [
            UIColor.systemIndigo, // for accessing
            UIColor.systemRed,
            UIColor.systemGreen,
            UIColor.systemYellow,
            UIColor.cyan,
            UIColor.systemIndigo
        ]
    }
}

// MARK: - CommentContentTableCell: CommentCell
class CommentContentTableCell: CommentCell, ContentFocusable {

    var appearance = Appearance()
    
    // MARK: - Properties
    let commentContentView = CommentContentView()
    let selBackView = UIView()
    
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
    func bind(with comment: LemmyModel.CommentView, level: Int, appearance: Appearance = Appearance()) {
        self.appearance = appearance
        
        commentContentView.bind(with: comment, setting: appearance.config)
        self.level = level
        
        if self.level > 0 {
            self.indentationIndicatorColor =
                self.appearance.indentColors[self.level % (self.appearance.indentColors.count - 1)]
        }
    }
    
    /// Change the value of the isFolded property. Add a color animation.
    func animateIsFolded(fold: Bool) {
        UIView.animateKeyframes(withDuration: 0.3, delay: 0.0, options: [], animations: {
            self.commentContentView.backgroundColor = UIColor.gray.withAlphaComponent(0.06)
        }, completion: { _ in
            
            UIView.animateKeyframes(withDuration: 0.3, delay: 0.0, options: [], animations: {
                self.commentContentView.backgroundColor = self.appearance.backgroundColor
            })
        })
    }

    // MARK: - Overrided
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        selBackView.backgroundColor = Config.Color.highlightCell
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
        selBackView.backgroundColor = Config.Color.highlightCell
        self.selectedBackgroundView = selBackView
        
        // comment cell
        self.backgroundColor = appearance.backgroundColor
        self.commentMarginColor = appearance.commentMarginColor
        self.rootCommentMargin = 8
        self.rootCommentMarginColor = appearance.rootCommentMarginColor
        self.commentMargin = 0
        self.isIndentationIndicatorsExtended = true
    }
    
    func addSubviews() {
        // see impl inside CommentCell's self.commentViewContent
        self.commentViewContent = commentContentView
    }
    
    func makeConstraints() { }
}
