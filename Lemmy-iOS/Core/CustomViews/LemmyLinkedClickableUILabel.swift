//
//  LemmyLinkedClickableUILabel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/28/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class LemmyLinkedClickableUILabel: UILabel {

    typealias YourCompletion = () -> Void

    var linkedRange: NSRange!
    var completion: YourCompletion?

    @objc func linkClicked(sender: UITapGestureRecognizer) {

        if let completionBlock = completion {

            let textView = UITextView(frame: self.frame)
            textView.text = self.text
            textView.attributedText = self.attributedText
            let index = textView.layoutManager.characterIndex(for: sender.location(in: self),
                                                              in: textView.textContainer,
                                                              fractionOfDistanceBetweenInsertionPoints: nil)

            if linkedRange.lowerBound <= index && linkedRange.upperBound >= index {

                completionBlock()
            }
        }
    }

/**
 *  This method will be used to set an attributed text specifying the linked text with a
 *  handler when the link is clicked
 */
    @discardableResult
    public func setLinkedTextWithHandler(text: String, link: String, handler: @escaping () -> Void) -> Bool {

        let attributextText = NSMutableAttributedString(string: text)
        let foundRange = attributextText.mutableString.range(of: link)

        if foundRange.location != NSNotFound {
            self.linkedRange = foundRange
            self.completion = handler
            attributextText.addAttribute(NSAttributedString.Key.link, value: text, range: foundRange)
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(linkClicked(sender:))))
            return true
        }
        return false
    }
}
