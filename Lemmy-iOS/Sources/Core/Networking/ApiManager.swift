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
    
    static var requests = RequestsManager()
    
    private let instanceUrl: String
    
    let requestsManager: RequestsManager?
    
    /// Use init?(instanceUrl:) if you want to create a new websocket connection with new instance
    init(instanceUrl: String) {
        self.instanceUrl = instanceUrl
        self.requestsManager = RequestsManager(instanceUrl: instanceUrl, isNewInstance: true)
    }
}
