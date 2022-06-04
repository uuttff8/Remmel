//
//  AttachmentTapGesture.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 02.02.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

class AttachmentTapGestureRecognizer: UITapGestureRecognizer {

    typealias TappedAttachment = (attachment: NSTextAttachment, characterIndex: Int)

    private(set) var tappedState: TappedAttachment?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        tappedState = nil

        guard let textView = view as? UITextView else {
            state = .failed
            return
        }

        if let touch = touches.first {
            tappedState = evaluateTouch(touch, on: textView)
        }

        if tappedState != nil {
            // UITapGestureRecognizer can accurately differentiate discrete taps from scrolling
            // Therefore, let the super view evaluate the correct state.
            super.touchesBegan(touches, with: event)

        } else {
            // User didn't initiate a touch (tap or otherwise) on an attachment.
            // Force the gesture to fail.
            state = .failed
        }
    }

    /// Tests to see if the user has tapped on a text attachment in the target text view.
    private func evaluateTouch(_ touch: UITouch, on textView: UITextView) -> TappedAttachment? {
        let point = touch.location(in: textView)
        let glyphIndex: Int = textView.layoutManager.glyphIndex(
            for: point,
            in: textView.textContainer,
            fractionOfDistanceThroughGlyph: nil
        )
        let glyphRect = textView.layoutManager.boundingRect(forGlyphRange: NSRange(location: glyphIndex, length: 1),
                                                            in: textView.textContainer)
        
        guard glyphRect.contains(point) else {
            return nil
        }
        let characterIndex: Int = textView.layoutManager.characterIndexForGlyph(at: glyphIndex)
        guard characterIndex < textView.textStorage.length else {
            return nil
        }
        guard NSTextAttachment.character == (textView.textStorage.string as NSString)
                .character(at: characterIndex) else {
            return nil
        }
        guard let attachment = textView.textStorage.attribute(.attachment, at: characterIndex, effectiveRange: nil) as? NSTextAttachment else {
            return nil
        }
        return (attachment, characterIndex)
    }
}
