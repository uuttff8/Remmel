//
//  File.swift
//  
//
//  Created by uuttff8 on 20/02/2023.
//

import Foundation

public enum LemmyGenericError: Error {
    case string(String)
    case error(Error)
    
    public var description: String {
        switch self {
        case .string(let str):
            return str
        case .error(let error):
            return error.localizedDescription
        }
    }
}
