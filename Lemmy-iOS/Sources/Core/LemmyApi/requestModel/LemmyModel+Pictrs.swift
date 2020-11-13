//
//  LemmyApiStructs+Pictrs.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 24.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

extension LemmyModel {
    enum Pictrs {

        // MARK: - Pictrs -
        struct PictrsResponse: Codable, Equatable, Hashable {
            let msg: String?
            let files: [PictrsFiles]
        }

        struct PictrsFiles: Codable, Equatable, Hashable {
            let file: String
            let deleteToken: String

            enum CodingKeys: String, CodingKey {
                case file
                case deleteToken = "delete_token"
            }
        }
    }
}
