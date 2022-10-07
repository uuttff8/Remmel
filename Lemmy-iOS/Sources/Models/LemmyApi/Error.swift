//
//  Error.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

enum LemmyGenericError: Error {
    case string(String)
    case error(Error)
    
    var description: String {
        switch self {
        case .string(let str):
            return str
        case .error(let error):
            return error.localizedDescription
        }
    }
}
