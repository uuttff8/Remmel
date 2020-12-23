//
//  ContentFocusable.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 24.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol ContentFocusable {
    func focusOnContent()
}

extension ContentFocusable where Self: UITableViewCell {
    func focusOnContent() {
        self.contentView.backgroundColor = Config.Color.highlightCell
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            UIView.animate(withDuration: 1.0) {
                self.contentView.backgroundColor = UIColor.systemBackground
            }

        }
    }
}
