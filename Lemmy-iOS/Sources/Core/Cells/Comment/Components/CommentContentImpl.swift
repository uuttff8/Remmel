//
//  CommentContentImpl.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 23.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

extension CommentContentCellView {
    struct Appearance {
        
        let backgroundColor = UIColor.systemBackground

        var config: CommentContentView.Setting = CommentContentView.Setting.list
    }
}

// MARK: - CommentContentCellView: CommentCell
class CommentContentCellView: UIView {
    
    var appearance = Appearance()
    
    // MARK: - Properties
    let commentContentView = CommentContentView()
    let selBackView = UIView()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
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
//        self.level = level
//
//        if self.level > 0 {
//            self.indentationIndicatorColor =
//                self.appearance.indentColors[self.level % (self.appearance.indentColors.count - 1)]
//        }
    }
    
    /// Change the value of the isFolded property. Add a color animation.
    func animateIsFolded(fold: Bool) {
        UIView.animateKeyframes(
            withDuration: 0.3,
            delay: 0.0,
            options: [],
            animations: {
                self.commentContentView.backgroundColor = UIColor.gray.withAlphaComponent(0.06)
            }, completion: { _ in

                UIView.animateKeyframes(withDuration: 0.3, delay: 0.0, options: [], animations: {
                    self.commentContentView.backgroundColor = self.appearance.backgroundColor
                })
            }
        )
    }

    // MARK: - Overrided
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        selBackView.backgroundColor = Config.Color.highlightCell
    }
    
    func prepareForReuse() {
        self.isHidden = false
//        self.isSelected = false
//        self.isHighlighted = false
        self.commentContentView.prepareForReuse()
    }
}

extension CommentContentCellView: ProgrammaticallyViewProtocol {
    func setupView() {
        selBackView.backgroundColor = Config.Color.highlightCell
//        self.selectedBackgroundView = selBackView
        
        // comment cell
        self.backgroundColor = appearance.backgroundColor
//        self.commentMarginColor = appearance.commentMarginColor
//        self.rootCommentMargin = 8
//        self.rootCommentMarginColor = appearance.rootCommentMarginColor
//        self.commentMargin = 0
//        self.isIndentationIndicatorsExtended = true
    }
    
    func addSubviews() {
        // see impl inside CommentCell's self.commentViewContent
//        self.commentViewContent = commentContentView
    }
    
    func makeConstraints() { }
}
