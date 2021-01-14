//
//  VoteButton.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 17.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

extension VoteButton {
    struct Appearance {
        let voteAnimationDuration: TimeInterval = 0.5
        let scaleValue: CGFloat = 0.8
        let transitionDistance: CGFloat = 10
        
        let upvotedColor: UIColor = .lemmyBlue
        let downvotedColor: UIColor = .systemRed
        
        lazy var upvotedImage = Config.Image.arrowUp.withTintColor(upvotedColor,
                                                                   renderingMode: .alwaysOriginal)
        
        lazy var downvotedImage = Config.Image.arrowDown.withTintColor(downvotedColor,
                                                                       renderingMode: .alwaysOriginal)
    }
}

final class VoteButton: ScaledButton {
    
    enum VoteType {
        case top
        case down
    }
    
    var scoreValue: LemmyVoteType {
        didSet {
            switch scoreValue {
            case .down: handleForDownCase()
            case .up: handleForUpCase()
            case .none: handleForNoneCase()
            }
        }
    }
    
    var appearance: Appearance
    
    let voteType: VoteType
    
    private lazy var animator = UIViewPropertyAnimator(
        duration: self.appearance.voteAnimationDuration,
        curve: .easeInOut
    )
    
    init(voteType: VoteType, appearance: Appearance = Appearance()) {
        self.voteType = voteType
        self.appearance = appearance
        self.scoreValue = .none
        super.init(frame: .zero)
    }
    
    // increase tap area
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: -20, dy: -20).contains(point)
    }
    
    // MARK: - Public API
    func setVoted(to type: LemmyVoteType) {
        self.scoreValue = type
        animateVote()
    }
    
    /// This action increase or decrease y value of this view
    private func animateVote() {
        guard isTransformAnimationEnded else { return }
        self.isTransformAnimationEnded = false
        self.isEnabled = false
        
        // FIXIT: For a unknown reason self.center.y is jump to incorrect position at start
//        let trDistance: CGFloat = voteType == .top
//            ? -appearance.transitionDistance
//            : appearance.transitionDistance
//
//        animator.addAnimations {
//            self.center.y -= trDistance
//        }
//
//        animator.startAnimation()
        
        self.isEnabled = true
        isTransformAnimationEnded = true
    }
    
    private func handleForNoneCase() {
        switch voteType {
        case .top:
            self.setImage(Config.Image.arrowUp, for: .normal)
        case .down:
            self.setImage(Config.Image.arrowDown, for: .normal)
        }
    }
    
    private func handleForUpCase() {
        switch voteType {
        case .top:
            self.setImage(self.appearance.upvotedImage, for: .normal)
        case .down:
            self.setImage(Config.Image.arrowDown, for: .normal)
        }
    }
    
    private func handleForDownCase() {
        switch voteType {
        case .top:
            self.setImage(Config.Image.arrowUp, for: .normal)
        case .down:
            self.setImage(self.appearance.downvotedImage, for: .normal)
        }
    }
}
