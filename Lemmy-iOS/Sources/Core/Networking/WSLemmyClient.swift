//
//  WSLemmy.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/11/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

class WSLemmyClient {
    
    var instanceUrl: String
    
    init(instanceUrl: String) {
        self.instanceUrl = instanceUrl.encodeUrl
    }
    
    func asyncSend<D: Codable>(on endpoint: String, data: D? = nil) -> Future<String, LemmyGenericError> {
        asyncWrapper(url: endpoint, data: data)
    }
    
    func send<D: Codable>(on endpoint: String, data: D? = nil, completion: @escaping (String) -> Void) {
        wrapper(url: endpoint, data: data, completion: completion)
    }
    
    private func asyncWrapper<D: Codable>(url: String, data: D? = nil) -> Future<String, LemmyGenericError> {
        Future { [self] promise in
            
            guard let reqStr = makeRequestString(url: url, data: data)
            else { return promise(.failure("Can't make request string".toLemmyError)) }
            
            Logger.commonLog.info(
            """
                Current Instance: \(instanceUrl)
                \(reqStr)
            """)
            
            let wsMessage = createWebsocketMessage(request: reqStr)
            guard let wsTask = createWebsocketTask(instanceUrl: String.cleanUpUrl(url: &instanceUrl)) else {
                return promise(.failure(.string("Failed to create webscoket task")))
            }
            
            wsTask.resume()
            
            wsTask.send(wsMessage) { (error) in
                if let error = error {
                    promise(.failure("WebSocket couldn’t send message because: \(error)".toLemmyError))
                }
            }
            
            wsTask.receive { (res) in
                switch res {
                case let .success(messageType):
                    promise(.success(self.handleMessage(type: messageType)))
                case let .failure(error):
                    promise(.failure(LemmyGenericError.error(error)))
                }
            }
        }
    }
    
    private func wrapper<D: Codable>(url: String, data: D? = nil, completion: @escaping (String) -> Void) {
        
        guard let reqStr = makeRequestString(url: url, data: data) else { return }
        Logger.commonLog.info(reqStr)
        
        let wsMessage = createWebsocketMessage(request: reqStr)
        guard let wsTask = createWebsocketTask(instanceUrl: String.cleanUpUrl(url: &instanceUrl)) else {
            Logger.commonLog.error("Failed to create webscoket task")
            return
        }
        
        wsTask.resume()
        
        wsTask.send(wsMessage) { (error) in
            if let error = error {
                Logger.commonLog.error("WebSocket couldn’t send message because: \(error)")
            }
        }
        
        wsTask.receive { (res) in
            switch res {
            case let .failure(error):
                Logger.commonLog.error(error)
            case let .success(messageType):
                completion(self.handleMessage(type: messageType))
            }
        }
    }
    
    private func makeRequestString<T: Codable>(url: String, data: T?) -> String? {
        if let data = data {
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            guard let orderJsonData = try? encoder.encode(data)
            else {
                Logger.commonLog.error("failed to encode data \(#file) \(#line)")
                return nil
            }
            let sss = String(data: orderJsonData, encoding: .utf8)!
            
            return """
            {"op": "\(url)","data": \(sss)}
            """
        } else {
            return """
            {"op":"\(url)","data":{}}
            """
        }
    }
    
    private func createWebsocketTask(instanceUrl: String) -> URLSessionWebSocketTask? {
        let endpoint = "wss://" + instanceUrl + "/api/v1/ws"
        let urlSession = URLSession(configuration: .default)
        if let url = URL(string: endpoint) {
            return urlSession.webSocketTask(with: url)
        }
        
        return nil
    }
    
    private func createWebsocketMessage(request: String) -> URLSessionWebSocketTask.Message {
        return URLSessionWebSocketTask.Message.string(request)
    }
    
    private func handleMessage(type: URLSessionWebSocketTask.Message) -> String {
        // handle only strings
        switch type {
        case let .string(outString):
            return outString
        default:
            break
        }
        
        return ""
    }
}

extension String {
    static func cleanUpUrl(url: inout String) -> String {
        if url.hasPrefix("https://") {
            url.removeFirst(8)
            return url
        }
        
        if url.hasPrefix("www.") {
            url.removeFirst(4)
            return url
        }
        
        if url.hasSuffix("/") {
            url.removeLast()
            return url
        }
        
        return url
    }
}

// wss://dev.lemmy.ml/api/v1/ws
