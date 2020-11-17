//
//  VoteButton.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 17.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class VoteButton: UIControl {
    
    init() {
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
            print("touchDown")
        case .touchDownRepeat:
            print("touchDownRepeat")
        case .touchUpInside:
            print("touchUpInside")
        case .touchUpOutside:
            print("touchUpOutside")
        case .touchDragEnter:
            print("touchDragEnter")
        case .touchDragExit:
            print("touchDragExit")
        case .touchDragInside:
            print("touchDragInside")
        case .touchDragOutside:
            print("touchDragOutside")
        default:
            print("Error: couldn't convert event to control event, or unhandled event case: \(event)")
        }
    }
}
