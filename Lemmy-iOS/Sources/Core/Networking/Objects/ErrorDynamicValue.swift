//
//  ErrorDynamicValue.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 21.02.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

class ErrorDynamicValue {
    typealias Completion = (Error)
    
    typealias CompletionHandler = ((_ error: Error) -> Void)

    var value: Completion {
        didSet {
            self.notify()
        }
    }

    private var observers = [String: CompletionHandler]()

    init(_ value: Completion) {
        self.value = value
    }

    func addObserver(_ observer: AnyObject, completionHandler: @escaping CompletionHandler) {
        observers[observer.description] = completionHandler
    }

    func addAndNotify(observer: AnyObject, completionHandler: @escaping CompletionHandler) {
        self.addObserver(observer, completionHandler: completionHandler)
        self.notify()
    }

    private func notify() {
        observers.forEach({ $0.value(value) })
    }

    deinit {
        observers.removeAll()
    }
}
