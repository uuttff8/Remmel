//
//  LemmyUITableView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class LemmyTableView: UITableView {
    init(style: UITableView.Style, separator: Bool = false) {
        super.init(frame: .zero, style: style)
        self.tableFooterView = UIView()
        self.rowHeight = UITableView.automaticDimension
//        self.estimatedRowHeight = 40
        self.keyboardDismissMode = .onDrag

        if separator {
            self.separatorStyle = .singleLine
        } else {
            self.separatorStyle = .none
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // https://www.rightpoint.com/rplabs/fixing-controls-and-scrolling-button-views-ios
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIControl
            && !(view is UITextInput)
            && !(view is UISlider)
            && !(view is UISwitch) {
            return true
        }

        return super.touchesShouldCancel(in: view)
    }
}
