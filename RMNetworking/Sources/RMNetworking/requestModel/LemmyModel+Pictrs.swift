//
//  LemmyApiStructs+Pictrs.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 24.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

public enum Pictrs {
    
    // MARK: - Pictrs -
    public struct PictrsResponse: Codable, Equatable, Hashable {
        public let msg: String?
        public let files: [PictrsFiles]
    }
    
    public struct PictrsFiles: Codable, Equatable, Hashable {
        public let file: String
        public let deleteToken: String
        
        enum CodingKeys: String, CodingKey {
            case file
            case deleteToken = "delete_token"
        }
    }
}
