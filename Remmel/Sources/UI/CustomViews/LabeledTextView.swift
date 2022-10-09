//
//  LemmyLinkedClickableUILabel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/28/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class LabeledTextView: UITextView {
    
    var numberOfLines: Int = 1 {
        didSet {
            self.textContainer.maximumNumberOfLines = numberOfLines
            self.textContainer.lineBreakMode = .byTruncatingTail
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        self.textContainerInset = .zero
        self.textContainer.lineFragmentPadding = 0
        self.sizeToFit()
        self.layoutManager.usesFontLeading = false
    }
}
