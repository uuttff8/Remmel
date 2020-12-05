//
//  UIStackView+Ext.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 04.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

extension UIStackView {
    /// The possible items in a stack view
    public enum StackViewItem {
        /// Place a view in the stack view
        case view(UIView)
        /// Set a custom space after the last item in the stack view
        case customSpace(CGFloat)
    }
    /// Adds a set of stack view items to make static UI creation a bit easier
    public func addStackViewItems(_ items: StackViewItem...) {
        
        items.forEach {
            switch $0 {
            case .view(let view):
                guard view !== self else { fatalError("Cant add subview item as self") }
                
                addArrangedSubview(view)
            case .customSpace(let space):
                
                guard let lastSubview = arrangedSubviews.last else {
                    assertionFailure("Cannot have a space as the first item.")
                    return
                }
                setCustomSpacing(space, after: lastSubview)
            }
        }
    }
}
