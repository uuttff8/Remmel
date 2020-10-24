//
//  RestLemmyEndpoint.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 24.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

enum HttpLemmyEndpoint {
    enum Pictrs: String {
        
        static let pictrs = "/pictrs"
        
        case image
        
        var endpoint: String {
            switch self {
            case .image: return "https://dev.lemmy.ml\(Self.pictrs)/image"
            }
        }
    }
}
