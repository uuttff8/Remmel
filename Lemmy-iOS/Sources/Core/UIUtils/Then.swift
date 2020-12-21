//
//  Then.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 04.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

// https://github.com/brave/brave-ios/blob/development/ThirdParty/Then.swift
// https://github.com/capnslipp/With/blob/master/Sources/With.swift

// Use then { } function where available, if not then use with(Type()) {  }

import Foundation
#if !os(Linux)
  import CoreGraphics
#endif
#if os(iOS) || os(tvOS)
  import UIKit.UIGeometry
#endif

public protocol Then {}

extension Then where Self: Any {

  /// Makes it available to set properties with closures just after initializing and copying the value types.
  ///
  ///     let frame = CGRect().with {
  ///       $0.origin.x = 10
  ///       $0.size.width = 100
  ///     }
  @inlinable
  public func with(_ block: (inout Self) throws -> Void) rethrows -> Self {
    var copy = self
    try block(&copy)
    return copy
  }

  /// Makes it available to execute something with closures.
  ///
  ///     UserDefaults.standard.do {
  ///       $0.set("devxoul", forKey: "username")
  ///       $0.set("devxoul@gmail.com", forKey: "email")
  ///       $0.synchronize()
  ///     }
  @inlinable
  public func `do`(_ block: (Self) throws -> Void) rethrows {
    try block(self)
  }

}

extension Then where Self: AnyObject {

  /// Makes it available to set properties with closures just after initializing.
  ///
  ///     let label = UILabel().then {
  ///       $0.textAlignment = .center
  ///       $0.textColor = UIColor.black
  ///       $0.text = "Hello, World!"
  ///     }
  @inlinable
  public func then(_ block: (Self) throws -> Void) rethrows -> Self {
    try block(self)
    return self
  }

}

extension NSObject: Then {}

#if !os(Linux)
  extension CGPoint: Then {}
  extension CGRect: Then {}
  extension CGSize: Then {}
  extension CGVector: Then {}
#endif

extension Array: Then {}
extension Dictionary: Then {}
extension Set: Then {}

#if os(iOS) || os(tvOS)
  extension UIEdgeInsets: Then {}
  extension UIOffset: Then {}
  extension UIRectEdge: Then {}
#endif

// MARK: Returning Subject
/// “With” on an object- or value-type subject, returning the same subject
/// (including any mutations performed in the closure).
@inlinable @discardableResult
public func with<SubjectT>(
    _ subject: SubjectT,
    _ operations: (inout SubjectT) throws -> Void
) rethrows -> SubjectT {
    var subject = subject
    try operations(&subject)
    return subject
}

// MARK: Returning Arbitrary Value
/// “With” on an object- or value-type subject, returning an aribitrary return object/value from the closure
///  (the subject is still mutated).
@inlinable
public func withMap<SubjectT, ReturnT>(
    _ subject: SubjectT,
    _ transform: (inout SubjectT) throws -> ReturnT
) rethrows -> ReturnT {
    var subject = subject
    return try transform(&subject)
}

