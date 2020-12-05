//
//  MultilineButton.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 05.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

@IBDesignable
class MultiLineButton: UIButton {

    // MARK: Setup
    func setup () {
        self.titleLabel?.numberOfLines = 0

        //The next two lines are essential in making sure autolayout sizes us correctly
        self.setContentHuggingPriority(UILayoutPriority.defaultLow + 1, for: .vertical)
        self.setContentHuggingPriority(UILayoutPriority.defaultLow + 1, for: .horizontal)
    }

    // MARK: Method overrides
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    override var intrinsicContentSize: CGSize {
        return self.titleLabel!.intrinsicContentSize
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.preferredMaxLayoutWidth = self.titleLabel!.frame.size.width
    }
}
