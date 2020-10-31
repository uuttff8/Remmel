//
//  ApiManager.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

final class ApiManager {
    static let shared = ApiManager()

    // MARK: - Internal properties
    lazy var requestsManager = RequestsManager()

    static var requests: RequestsManager {
        ApiManager.shared.requestsManager
    }
}
