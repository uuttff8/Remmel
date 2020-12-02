//
//  VoteButtonsWithScoreView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 01.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import FrameLayoutKit

class VoteButtonsWithScoreView: UIView {
    
    struct ViewData {
        let score: Int
        var voteType: LemmyVoteType
    }
    
    var viewData: ViewData?
    
    var upvoteButtonTap: ((VoteButton, LemmyVoteType) -> Void)?
    var downvoteButtonTap: ((VoteButton, LemmyVoteType) -> Void)?
    
    private let frameLayout = StackFrameLayout(axis: .horizontal)
    
    private let upvoteBtn = VoteButton(voteType: .top).then {
        $0.setImage(Config.Image.arrowUp, for: .normal)
    }
    
    private let downvoteBtn = VoteButton(voteType: .down).then {
        $0.setImage(Config.Image.arrowDown, for: .normal)
    }
    
    private let scoreLabel = UILabel().then {
        $0.textAlignment = .center
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
        self.scoreLabel.text = String(viewData.score)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        upvoteBtn.setImage(Config.Image.arrowUp, for: .normal)
        downvoteBtn.setImage(Config.Image.arrowDown, for: .normal)
    }
    
    @objc private func upvoteButtonTapped(sender: VoteButton!) {
        if let viewData = viewData {

            // TODO: handle if no login

            let type = viewData.voteType == .up ? .none : LemmyVoteType.up
            self.viewData?.voteType = type

            downvoteBtn.scoreValue = .none
            upvoteButtonTap?(sender, type)
        }
    }
    
    @objc private func downvoteButtonTapped(sender: VoteButton!) {
        if let viewData = viewData {

            // TODO: handle if no login

            let type = viewData.voteType == .down ? .none : LemmyVoteType.down
            self.viewData?.voteType = type

            upvoteBtn.scoreValue = .none
            downvoteButtonTap?(sender, type)
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return frameLayout.sizeThatFits(size)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        frameLayout.frame = bounds
    }
}

extension VoteButtonsWithScoreView: ProgrammaticallyViewProtocol {
    func setupView() {
    }
    
    func addSubviews() {
        self.addSubview(frameLayout)
    }
    
    func makeConstraints() {
        frameLayout + HStackLayout {
            $0.spacing = 8
            $0.distribution = .equal
            $0.alignment = (.center , .center)
            
            ($0 + upvoteBtn).extendSize = CGSize(width: 22, height: 22)
            $0 + scoreLabel
            ($0 + downvoteBtn).extendSize = CGSize(width: 22, height: 22)
        }
    }
}
