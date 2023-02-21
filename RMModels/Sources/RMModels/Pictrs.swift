//
//  File.swift
//  
//
//  Created by uuttff8 on 20/02/2023.
//

import Foundation

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
