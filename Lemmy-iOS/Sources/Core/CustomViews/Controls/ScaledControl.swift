//
//  ScaledControl.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 04.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class ScaledButton: UIButton {
    let scaleAnimationDuration: TimeInterval = 0.15    
    let scaleValue: CGFloat = 0.8
    
    var isTransformAnimationEnded = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addTarget(self, action: #selector(handleTouchEvent(_:forEvent:)), for: .allTouchEvents)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    @objc private func handleTouchEvent(_ sender: VoteButton, forEvent event: UIEvent) {
        guard let controlEvent = event.firstTouchToControlEvent() else {
            print("Error: couldn't convert event to control event: \(event)")
            return
        }
        switch controlEvent {
        case .touchDown, .touchDragInside:
            animateScaleButton(shouldDown: true)
        case .touchUpInside, .touchDragOutside, .touchUpOutside, .touchCancel:
            animateScaleButton(shouldDown: false)
        case .touchDragEnter, .touchDragExit, .touchDownRepeat:
            break
        default:
            print("Error: couldn't convert event to control event, or unhandled event case: \(controlEvent)")
        }
    }
    
    private func animateScaleButton(shouldDown: Bool) {
        guard isTransformAnimationEnded else { return }
        self.isTransformAnimationEnded = false
        self.isEnabled = false
        
        let transformed = shouldDown ?
            CGAffineTransform(scaleX: scaleValue, y: scaleValue)
            : .identity
        
        UIView.animate(
            withDuration: scaleAnimationDuration,
            delay: 0.0,
            options: [.curveEaseIn],
            animations: {
                self.transform = transformed
            }
        )
        
        self.isEnabled = true
        isTransformAnimationEnded = true
    }
}
