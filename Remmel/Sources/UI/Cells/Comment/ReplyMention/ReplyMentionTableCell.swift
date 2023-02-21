//
//  ReplyMentionCellView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 07.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit
import Nuke
import RMModels

extension ReplyMentionTableCell {
    struct Appearance {
        
        var config: CommentContentView.Setting = CommentContentView.Setting.inPost
        
        let backgroundColor = UIColor.systemBackground
    }
}

// MARK: - CommentContentTableCell: CommentCell
class ReplyMentionTableCell: UITableViewCell, ContentFocusable {

    var appearance = Appearance()
    
    // MARK: - Properties
    let commentContentView = ReplyMentionCellView()
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
    func configure(with reply: RMModels.Views.CommentView, level: Int, appearance: Appearance = Appearance()) {
        self.appearance = appearance
        
        commentContentView.configure(reply: reply)
    }
    
    func configure(with mention: RMModels.Views.PersonMentionView, level: Int, appearance: Appearance = Appearance()) {
        self.appearance = appearance
        
        commentContentView.configure(mention: mention)
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

extension ReplyMentionTableCell: ProgrammaticallyViewProtocol {
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
