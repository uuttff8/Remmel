//
//  PostContentPreviewTableCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 19.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol PostContentPreviewTableCellDelegate: AnyObject {
    func voteContent(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        newVote: LemmyVoteType,
        post: LemmyModel.PostView
    )
    func usernameTapped(with mention: LemmyUserMention)
    func communityTapped(with mention: LemmyCommunityMention)
    func showMore(in post: LemmyModel.PostView)
    func postCellDidSelected(postId: LemmyModel.PostView.ID)
}

class PostContentPreviewTableCell: UITableViewCell {
    
    var postContentView = PostContentPreviewView()
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

    // TODO: refactor this
    func bind(with post: LemmyModel.PostView, isInsideCommunity: Bool) {
        if isInsideCommunity {
            postContentView.bind(with: post, config: .insideComminity)
        } else {
            postContentView.bind(with: post, config: .preview)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        selBackView.backgroundColor = Config.Color.highlightCell
    }
    
    override func prepareForReuse() {
        postContentView.prepareForReuse()
    }
}

extension PostContentPreviewTableCell: ProgrammaticallyViewProtocol {
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
