//
//  PostContentTableCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import DateToolsSwift
import SwiftyMarkdown
import Nantes

protocol PostContentTableCellDelegate: AnyObject {
    func voteContent(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        newVote: LemmyVoteType,
        post: LemmyModel.PostView
    )
    func usernameTapped(in post: LemmyModel.PostView)
    func communityTapped(in post: LemmyModel.PostView)
    func onLinkTap(in post: LemmyModel.PostView, url: URL)
    func onMentionTap(in post: LemmyModel.PostView, mention: LemmyMention)
    func showMore(in post: LemmyModel.PostView)
}

class PostContentTableCell: UITableViewCell {
    
    var postContentView = PostContentView()
    let selBackView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        setupView()
        addSubviews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with post: LemmyModel.PostView, config: PostContentType) {
        postContentView.bind(with: post, config: config)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        selBackView.backgroundColor = Config.Color.highlightCell
    }
    
    override func prepareForReuse() {
        postContentView.prepareForReuse()
    }
}

extension PostContentTableCell: ProgrammaticallyViewProtocol {
    func setupView() {
        selBackView.backgroundColor = Config.Color.highlightCell
        self.selectedBackgroundView = selBackView
    }
    
    func addSubviews() {
        self.contentView.addSubview(postContentView)
    }
    
    func makeConstraints() {
        self.postContentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
