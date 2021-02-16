//
//  BlockObject.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 17.02.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol Actionable {
    associatedtype T = Self
    func addAction(for controlEvent: UIControl.Event, action: ((T) -> Void)?)
}

private class ClosureSleeve<T> {
    let closure: ((T) -> Void)?
    let sender: T

    init (sender: T, _ closure: ((T) -> Void)?) {
        self.closure = closure
        self.sender = sender
    }

    @objc func invoke() {
        closure?(sender)
    }
}

extension Actionable where Self: UIControl {
    func addAction(for controlEvent: UIControl.Event, action: ((Self) -> Void)?) {
        let previousSleeve = objc_getAssociatedObject(self, String(controlEvent.rawValue))
        objc_removeAssociatedObjects(previousSleeve as Any)
        removeTarget(previousSleeve, action: nil, for: controlEvent)

        let sleeve = ClosureSleeve(sender: self, action)
        addTarget(sleeve, action: #selector(ClosureSleeve<Self>.invoke), for: controlEvent)
        objc_setAssociatedObject(self, String(controlEvent.rawValue), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}

extension UIControl: Actionable {}
