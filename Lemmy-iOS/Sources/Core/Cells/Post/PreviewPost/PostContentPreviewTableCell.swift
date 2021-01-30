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
        post: LMModels.Views.PostView
    )
    func usernameTapped(with mention: LemmyUserMention)
    func communityTapped(with mention: LemmyCommunityMention)
    func showMore(in post: LMModels.Views.PostView)
    func postCellDidSelected(postId: LMModels.Views.PostView.ID)
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

    func bind(with post: LMModels.Views.PostView, isInsideCommunity: Bool) {
        if isInsideCommunity {
            postContentView.bind(with: post, config: .insideComminity)
        } else {
            postContentView.bind(with: post, config: .preview)
        }
    }
    
    func updateForCreatePostLike(post: LMModels.Views.PostView) {
        postContentView.updateForCreatePostLike(post: post)
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
