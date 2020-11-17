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
        let scaleAnimationDuration: TimeInterval = 0.15
        let voteAnimationDuration: TimeInterval = 0.1
        
        let scaleValue: CGFloat = 0.8
        let transitionDistance: CGFloat = 15
        
        let upvotedColor: UIColor = .systemBlue
        let downvotedColor: UIColor = .systemRed
        
        lazy var upvotedImage = Config.Image.arrowUp.withTintColor(upvotedColor,
                                                                   renderingMode: .alwaysOriginal)
        
        lazy var downvotedImage = Config.Image.arrowDown.withTintColor(downvotedColor,
                                                                       renderingMode: .alwaysOriginal)
    }
}

final class VoteButton: UIButton {
    
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
    
    private let voteType: VoteType
    
    var isTransformAnimationEnded = true
    
    init(voteType: VoteType, appearance: Appearance = Appearance()) {
        self.voteType = voteType
        self.appearance = appearance
        self.scoreValue = .none
        super.init(frame: .zero)
        
        self.addTarget(self, action: #selector(handleTouchEvent(_:forEvent:)), for: .allTouchEvents)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleTouchEvent(_ sender: VoteButton, forEvent event: UIEvent) {
        guard let controlEvent = event.firstTouchToControlEvent() else {
            print("Error: couldn't convert event to control event: \(event)")
            return
        }
        switch controlEvent {
        case .touchDown:
            animateScaleButton(shouldDown: true)
        case .touchDownRepeat:
            break
        case .touchUpInside:
            animateScaleButton(shouldDown: false)
        case .touchUpOutside:
            animateScaleButton(shouldDown: false)
        case .touchDragEnter:
            break
        case .touchDragExit:
            break
        case .touchDragInside:
            animateScaleButton(shouldDown: true)
        case .touchDragOutside:
            animateScaleButton(shouldDown: false)
        default:
            print("Error: couldn't convert event to control event, or unhandled event case: \(event)")
        }
    }
    
    func animateScaleButton(shouldDown: Bool) {
        guard isTransformAnimationEnded else { return }
        self.isTransformAnimationEnded = false
        self.isEnabled = false
        
        let transformed = shouldDown ?
            CGAffineTransform(scaleX: appearance.scaleValue, y: appearance.scaleValue)
            : .identity
        
        UIView.animate(
            withDuration: appearance.scaleAnimationDuration,
            delay: 0.0,
            options: [.curveEaseIn],
            animations: {
                self.transform = transformed
            }
        )
        
        self.isEnabled = true
        isTransformAnimationEnded = true
    }
    
    func animateVote() {
        guard isTransformAnimationEnded else { return }
        self.isTransformAnimationEnded = false
        self.isEnabled = false
        
        let trDistance: CGFloat = voteType == .top ?
            -appearance.transitionDistance
            : appearance.transitionDistance
                
        UIView.animate(
            withDuration: 0.1,
            delay: 0.0,
            options: [.curveEaseIn],
            animations: {
                self.center.y += trDistance
            },
            completion: { [self] (_) in
                
                UIView.animate(
                    withDuration: appearance.voteAnimationDuration,
                    delay: 0.0,
                    options: [.curveEaseIn],
                    animations: {
                        self.center.y -= trDistance
                    }
                )
                
            }
        )
        
        self.isEnabled = true
        isTransformAnimationEnded = true
    }
    
    func setVoted(to type: LemmyVoteType) {
        self.scoreValue = type
        animateVote()
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
