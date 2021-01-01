//
//  VoteButtonsWithScoreView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 01.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class VoteButtonsWithScoreView: UIView {
    
    struct ViewData {
        let score: Int
        var voteType: LemmyVoteType
    }
    
    var viewData: ViewData?
    
    private var lastKnownVoteType: LemmyVoteType = .none
    private var lastKnownVoteScore: Int = 0
    
    var upvoteButtonTap: ((VoteButtonsWithScoreView, VoteButton, LemmyVoteType) -> Void)?
    var downvoteButtonTap: ((VoteButtonsWithScoreView, VoteButton, LemmyVoteType) -> Void)?
        
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
    }
    
    let upvoteBtn = VoteButton(voteType: .top)
    let downvoteBtn = VoteButton(voteType: .down)
    
    private let scoreLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = $0.font.monospacedDigitFont
    }
    
    init() {
        super.init(frame: .zero)
        
        downvoteBtn.addTarget(self, action: #selector(downvoteButtonTapped(sender:)), for: .touchUpInside)
        upvoteBtn.addTarget(self, action: #selector(upvoteButtonTapped(sender:)), for: .touchUpInside)
        
        setupView()
        addSubviews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with viewData: ViewData) {
        self.viewData = viewData
        
        upvoteBtn.scoreValue = viewData.voteType
        downvoteBtn.scoreValue = viewData.voteType
        
        self.lastKnownVoteType = viewData.voteType
        self.lastKnownVoteScore = viewData.score
        self.scoreLabel.text = String(viewData.score)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        upvoteBtn.setImage(Config.Image.arrowUp, for: .normal)
        downvoteBtn.setImage(Config.Image.arrowDown, for: .normal)
    }
    
    func setVoted(voteButton: VoteButton, to newVote: LemmyVoteType) {
        voteButton.setVoted(to: newVote)
        
        switch newVote {
        case .none:
            resetScoreToDefaults()
        case .up:
            updateScoreUp()
        case .down:
            updateScoreDown()
        }
    }
    
    @objc private func upvoteButtonTapped(sender: VoteButton!) {
        if let viewData = viewData {
                        
            let type = viewData.voteType == .up ? .none : LemmyVoteType.up
            self.viewData?.voteType = type
            
            downvoteBtn.scoreValue = .none
            upvoteButtonTap?(self, sender, type)
        }
    }
    
    @objc private func downvoteButtonTapped(sender: VoteButton!) {
        if let viewData = viewData {
            
            let type = viewData.voteType == .down ? .none : LemmyVoteType.down
            self.viewData?.voteType = type
            
            upvoteBtn.scoreValue = .none
            downvoteButtonTap?(self, sender, type)
        }
    }
    
    private func updateScoreUp() {
        
        switch lastKnownVoteType {
        case .up:
            resetScoreToDefaults()
        case .down:
            self.scoreLabel.text = String(self.lastKnownVoteScore + 2)
            self.lastKnownVoteScore += 2
            self.lastKnownVoteType = .up
        case .none:
            self.scoreLabel.text = String(self.lastKnownVoteScore + 1)
            self.lastKnownVoteScore += 1
            self.lastKnownVoteType = .up
        }
    }
    
    private func updateScoreDown() {
        
        switch lastKnownVoteType {
        case .up:
            
            self.scoreLabel.text = String(self.lastKnownVoteScore - 2)
            self.lastKnownVoteScore -= 2
            self.lastKnownVoteType = .down
            
        case .down:
            resetScoreToDefaults()
        case .none:
            self.scoreLabel.text = String(self.lastKnownVoteScore - 1)
            self.lastKnownVoteScore -= 1
            self.lastKnownVoteType = .down
        }
    }
    
    private func resetScoreToDefaults() {
        guard let initialViewData = viewData else { return }
        
        self.scoreLabel.text = String(initialViewData.score)
        self.lastKnownVoteScore = initialViewData.score
        self.lastKnownVoteType = .none
    }

}

extension VoteButtonsWithScoreView: ProgrammaticallyViewProtocol {
    func setupView() {
    }
    
    func addSubviews() {
        self.addSubview(stackView)
        stackView.addStackViewItems(
            .view(upvoteBtn),
            .view(scoreLabel),
            .view(downvoteBtn)
        )
    }
    
    func makeConstraints() {        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
