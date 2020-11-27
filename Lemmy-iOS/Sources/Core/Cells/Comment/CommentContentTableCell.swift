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
    func upvote(comment: LemmyModel.CommentView)
    func downvote(comment: LemmyModel.CommentView)
    func showContext(in comment: LemmyModel.CommentView)
    func reply(to comment: LemmyModel.CommentView)
    func showMoreAction(in comment: LemmyModel.CommentView)
}

extension CommentContentTableCell {
    struct Appearance {
        let rootCommentMarginColor = UIColor.systemBackground
        let rootCommentMargin: CGFloat = 10
        let commentMarginColor = UIColor.systemBackground
        let commentMargin: CGFloat = 1
        let identationColor = UIColor.black
        let commentBackgroundColor = UIColor.red
        let indentationIndicatorColor = UIColor.gray
        let indentationIndicatorThickness: CGFloat = 1
        let backgroundColor = UIColor.systemBackground
    }
}

// MARK: - CommentContentTableCell: CommentCell
class CommentContentTableCell: CommentCell {

    let appearance = Appearance()
    
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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public API
    func bind(with comment: LemmyModel.CommentView) {
        commentContentView.bind(with: comment)
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
        self.indentationIndicatorColor = appearance.identationColor
        self.commentMargin = 0
        self.isIndentationIndicatorsExtended = true
    }
    
    func addSubviews() {
        // see impl inside CommentCell's self.commentViewContent
        self.commentViewContent = commentContentView
    }
    
    func makeConstraints() { }
}
