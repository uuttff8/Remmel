//
//  PostContentFooterView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 01.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

// MARK: - PostContentFooterView: UIView
class PostContentFooterView: UIView {
    struct ViewData {
        let score: Int
        let myVote: Int?
        let numberOfComments: Int
        var voteType: LemmyVoteType
    }
    
    // MARK: - Properties
    var upvoteButtonTap: ((VoteButton, LemmyVoteType) -> Void)?
    var downvoteButtonTap: ((VoteButton, LemmyVoteType) -> Void)?
    
    private let iconSize = CGSize(width: 20, height: 20)
    
    private let upvoteBtn = VoteButton(voteType: .top).then {
        $0.setImage(Config.Image.arrowUp, for: .normal)
    }
    
    private let downvoteBtn = VoteButton(voteType: .down).then {
        $0.setImage(Config.Image.arrowDown, for: .normal)
    }
    
    let scoreLabel = UILabel()
    
    private let commentBtn = UIButton().then {
        $0.setImage(Config.Image.comments, for: .normal)
        $0.setInsets(forContentPadding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5),
                     imageTitlePadding: 5)
        $0.setTitleColor(.label, for: .normal)
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .leading
    }
    
    private var viewData: ViewData?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.addSubview(stackView)
        
        stackView.addStackViewItems(
            .view(upvoteBtn),
            .view(scoreLabel),
            .view(downvoteBtn),
            .view(UIView()),
            .view(commentBtn)
        )
        
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        setupTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Bind
    func bind(with data: PostContentFooterView.ViewData) {
        self.viewData = data
        
        scoreLabel.text = String(data.score)
        upvoteBtn.scoreValue = data.voteType
        downvoteBtn.scoreValue = data.voteType
        commentBtn.setTitle(String(data.numberOfComments), for: .normal)
    }
    
    // MARK: - Overrided
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        upvoteBtn.setImage(Config.Image.arrowUp, for: .normal)
        downvoteBtn.setImage(Config.Image.arrowDown, for: .normal)
        commentBtn.setImage(Config.Image.comments, for: .normal)
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 30)
    }
    
    // MARK: - Private
    private func setupTargets() {
        downvoteBtn.addTarget(self, action: #selector(downvoteButtonTapped(sender:)), for: .touchUpInside)
        upvoteBtn.addTarget(self, action: #selector(upvoteButtonTapped(sender:)), for: .touchUpInside)
    }
    
    @objc private func upvoteButtonTapped(sender: VoteButton!) {
        if let viewData = viewData {
            let type = viewData.voteType == .up ? .none : LemmyVoteType.up
            self.viewData?.voteType = type
            
            downvoteBtn.scoreValue = .none
            upvoteButtonTap?(sender, type)
        }
    }
    
    @objc private func downvoteButtonTapped(sender: VoteButton!) {
        if let viewData = viewData {
            let type = viewData.voteType == .down ? .none : LemmyVoteType.down
            self.viewData?.voteType = type
            
            upvoteBtn.scoreValue = .none
            downvoteButtonTap?(sender, type)
        }
    }
}

