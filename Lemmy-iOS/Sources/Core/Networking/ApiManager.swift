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
    
    static var requests: RequestsManager {
        RequestsManager(instanceUrl: ApiManager.currentInstance)
    }
    
    /// You should change it ONLY when changing current intance url
    class var currentInstance: String {
        "lemmy.ml"
    }
    
    private let instanceUrl: String
    
    lazy var requestsManager = RequestsManager(instanceUrl: instanceUrl)
    
    /// Use init(instanceUrl:) if you want to create a new websocket connection with new instance
    init(instanceUrl: String) {
        self.instanceUrl = instanceUrl
        self.requestsManager = RequestsManager(instanceUrl: instanceUrl)
    }
}
