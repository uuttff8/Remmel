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
    var upvoteButtonTap: ((VoteButtonsWithScoreView, VoteButton, LemmyVoteType) -> Void)?
    var downvoteButtonTap: ((VoteButtonsWithScoreView, VoteButton, LemmyVoteType) -> Void)?
        
    private let upvoteDownvoteButtons = VoteButtonsWithScoreView()
    
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
            .view(upvoteDownvoteButtons),
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
        upvoteDownvoteButtons.bind(with: .init(score: data.score, voteType: data.voteType))
        commentBtn.setTitle(String(data.numberOfComments), for: .normal)
    }    
    
    // MARK: - Overrided
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        commentBtn.setImage(Config.Image.comments, for: .normal)
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 30)
    }
    
    // MARK: - Private
    private func setupTargets() {
        upvoteDownvoteButtons.upvoteButtonTap = {
            self.upvoteButtonTap?($0, $1, $2)
        }
        upvoteDownvoteButtons.downvoteButtonTap = {
            self.downvoteButtonTap?($0, $1, $2)
        }
    }    
}
