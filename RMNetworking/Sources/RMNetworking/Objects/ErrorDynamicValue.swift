//
//  ErrorDynamicValue.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 21.02.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

public class ErrorDynamicValue {
    public typealias Completion = (Error)
    
    public typealias CompletionHandler = ((_ error: Error) -> Void)

    public var value: Completion {
        didSet {
            self.notify()
        }
    }

    private var observers = [String: CompletionHandler]()

    public init(_ value: Completion) {
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
        observers.forEach({ $0.value(value) })
    }

    deinit {
        observers.removeAll()
    }
}
