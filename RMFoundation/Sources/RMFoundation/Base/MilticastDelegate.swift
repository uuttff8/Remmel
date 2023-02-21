//
//  MilticastDelegate.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

// Value types doesn't supports, because it may run into strong reference cycles.
public final class MulticastDelegate<T: AnyObject> {
    
    public init() {}
    
    private var delegates = [WeakBox<T>]()

    /// Adds an element to the delegates collection.
    /// - Parameter delegate: The element to add to the delegates collection.
    public func add(_ delegate: T) {
        if !self.delegates.contains(where: { $0.value === delegate }) {
            self.delegates.append(WeakBox(delegate))
        }
    }

    /// Removes specified delegate.
    /// - Parameter delegate: The element to remove from the delegates collection.
    public func remove(_ delegate: T) {
        if let index = self.delegates.firstIndex(where: { $0.value === delegate }) {
            self.delegates.remove(at: index)
        }
    }

    /// Enumerates the delegates collection with the specified block to perform over an delegate.
    /// - Parameter block: The block perform over the delegate.
    public func invoke(_ block: (T) -> Void) {
        // Enumerating in reverse order prevents a race condition from happening when removing elements.
        for (index, boxedDelegate) in self.delegates.enumerated().reversed() {
            if let delegate = boxedDelegate.value {
                block(delegate)
            } else {
                // ARC killed `value` object, get rid of the element.
                self.delegates.remove(at: index)
            }
        }
    }
}
