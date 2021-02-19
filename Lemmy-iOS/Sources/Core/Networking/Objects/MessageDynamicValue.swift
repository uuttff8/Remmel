//
//  MessageDynamicValue.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 20.02.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

class MessageDynamicValue {
    typealias Completion = (String, Data)
    
    typealias CompletionHandler = ((_ op: String, _ data: Data) -> Void)

    var value: Completion {
        didSet {
            self.notify()
        }
    }

    private var observers = [String: CompletionHandler]()

    init(_ value: Completion) {
        self.value = value
    }

    public func addObserver(_ observer: AnyObject, completionHandler: @escaping CompletionHandler) {
        observers[observer.description] = completionHandler
    }

    public func addAndNotify(observer: AnyObject, completionHandler: @escaping CompletionHandler) {
        self.addObserver(observer, completionHandler: completionHandler)
        self.notify()
    }

    private func notify() {
        observers.forEach({ $0.value(value.0, value.1) })
    }

    deinit {
        observers.removeAll()
    }
}
