//
//  UniqueIdentifierType.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 19.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

public typealias UniqueIdentifierType = String

public protocol UniqueIdentifiable {
    var uniqueIdentifier: UniqueIdentifierType { get }
}
