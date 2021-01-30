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
    
    public var instanceUrl: URL
    
    private var webSocketTask: URLSessionWebSocketTask?
    private let urlSession: URLSession
    
    private let encoder = JSONEncoder()
    
    init(url: URL) {
        self.instanceUrl = url
        self.urlSession = URLSession(configuration: .default)
        self.webSocketTask = urlSession.webSocketTask(with: url)

        Logger.commonLog.info("URLSession webSocketTask opened to \(url)")
    }

    @available(*, deprecated, message: "Legacy method, use use full-flow connect()")
    func asyncSend<D: Codable>(on endpoint: String, data: D? = nil) -> AnyPublisher<String, LemmyGenericError> {
        asyncWrapper(url: endpoint, data: data)
            .eraseToAnyPublisher()
    }
    
    private func asyncWrapper<D: Codable>(url: String, data: D? = nil) -> AnyPublisher<String, LemmyGenericError> {
        Future { [self] promise in
            
            guard let reqStr = makeRequestString(url: url, data: data) else {
                return promise(.failure("Can't make request string".toLemmyError))
            }
            Logger.commonLog.info(reqStr)
            
            let wsMessage = createWebsocketMessage(request: reqStr)
            
            // Creating new websocket task to use API as Rest API, it is faster than HTTP
            self.webSocketTask = urlSession.webSocketTask(with: instanceUrl)
            webSocketTask?.resume()
            
            webSocketTask?.send(wsMessage) { (error) in
                if let error = error {
                    promise(.failure("WebSocket couldn’t send message because: \(error)".toLemmyError))
                }
            }
            
            webSocketTask?.receive { (res) in
                switch res {
                case let .success(messageType):
                    promise(.success(self.handleMessage(type: messageType)))
                    
                    // if we call websocketTask?.cancel() then new connection will not be performed
                    self.webSocketTask = nil
                case let .failure(error):
                    promise(.failure(LemmyGenericError.error(error)))
                    
                    // see above
                    self.webSocketTask = nil
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func makeRequestString<T: Codable>(url: String, data: T?) -> String? {
        if let data = data {
            
            encoder.outputFormatting = .prettyPrinted
            guard let orderJsonData = try? encoder.encode(data)
            else {
                Logger.commonLog.error("failed to encode data \(#file) \(#line)")
                return nil
            }
            let parameters = String(data: orderJsonData, encoding: .utf8)!
            
            return """
            {"op": "\(url)","data": \(parameters)}
            """
        } else {
            return """
            {"op":"\(url)","data":{}}
            """
        }
    }
    
    private func createWebsocketTask(url: URL) -> URLSessionWebSocketTask? {
        let urlSession = URLSession(configuration: .default)
        return urlSession.webSocketTask(with: url)
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
    static func cleanUpUrl(url: String) -> String {
        if url.hasPrefix("https://") {
            var url = url
            url.removeFirst(8)
            return url
        }
        
//        if url.hasPrefix("www.") {
//            var url = url
//            url.removeFirst(4)
//            return url
//        }
        
        if url.hasSuffix("/") {
            var url = url
            url.removeLast()
            return url
        }
        
        return url
    }
}

// wss://dev.lemmy.ml/api/v1/ws
