//
//  ApiManager.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

typealias LemmyResult<Output> = Result<Output, LemmyGenericError>

final class ApiManager {
    
    static let shared = ApiManager(instanceUrl: ApiManager.currentInstance)

    // MARK: - Internal properties
    
    let instanceUrl: String
    
    lazy var requestsManager = RequestsManager(instanceUrl: instanceUrl)

    static var requests: RequestsManager {
        ApiManager.shared.requestsManager
    }
    
    class var currentInstance: String {
        ""
    }
    
    init(instanceUrl: String) {
        self.instanceUrl = instanceUrl
    }
}
