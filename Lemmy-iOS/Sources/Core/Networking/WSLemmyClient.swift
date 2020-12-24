//
//  WSLemmy.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/11/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

public enum NetworkCloseError: Error {
    case socketReceiveFailure(Error)
    case socketPingFailure(Error)
    case socketSendFailure(Error)
    
    public var errorCode: String {
        switch self {
        case .socketReceiveFailure: return "3000"
        case .socketPingFailure: return "3001"
        case .socketSendFailure: return "3002"
        }
    }
    
    public var errorDescription: String {
        switch self {
        case .socketReceiveFailure(let error): return error.localizedDescription
        case .socketPingFailure(let error): return error.localizedDescription
        case .socketSendFailure(let error): return error.localizedDescription
        }
    }
}

public protocol WebsocketHandlerProtocol {
    var subject: PassthroughSubject<URLSessionWebSocketTask.Message, NetworkCloseError> { get }
    
    func start()
    func receiveMessage()
    func ping()
    func send(message: URLSessionWebSocketTask.Message)
    func close()
}

class WSLemmyClient: WebsocketHandlerProtocol {
    
    public private(set) var subject = PassthroughSubject<URLSessionWebSocketTask.Message, NetworkCloseError>()
    let instanceUrl: String
    private var webSocketTask: URLSessionWebSocketTask
    
    private let requestQueue = DispatchQueue(label: "Lemmy-iOS.RequestQueue")
    private let encoder = JSONEncoder()
    
    init(instanceUrl: String) {
        self.instanceUrl = instanceUrl
        
        let instanceUrl = String.cleanUpUrl(url: instanceUrl)
        let url = URL(string: "wss://" + instanceUrl + "/api/v1/ws")!
        
        let urlSession = URLSession(configuration: .default)
        self.webSocketTask = urlSession.webSocketTask(with: url)

        Logger.commonLog.info("URLSession webSocketTask opened to \(instanceUrl)")
    }
    
    func start() {
        Logger.commonLog.info("Start WebSocketTask Session")
        webSocketTask.resume()
        receiveMessage()
    }
        
    public func ping() {
        Logger.commonLog.info("PING Websocket")
        webSocketTask.sendPing { [weak self] error in
            guard let error = error else { return }
            self?.subject.send(completion: .failure(.socketPingFailure(error)))
            Logger.commonLog.error("SocketPingFailure: \(error.localizedDescription)")
        }
    }
    
    public func receiveMessage() {
        webSocketTask.receive { [weak self] result in
            switch result {
            case .failure(let error):
                self?.subject.send(completion: .failure(.socketReceiveFailure(error)))
                Logger.commonLog.error("SocketReceiveFailure: \(error.localizedDescription)")
            case .success(let message):
                self?.subject.send(message)
                
                guard case .string(let message) = message else { return }
                let op = message.convertToDictionary()!["op"] as! String
                let type: LemmyModel.Post.GetPostsResponse.Type = WSResponseMapper(op: op)!
                
                let decoder = LemmyJSONDecoder()
                
                do {
                    let response = try decoder.decode(RequestsManager.ApiResponse<LemmyModel.Post.GetPostsResponse
                    >.self, from: message.data(using: .utf8)!)
                    print(response)
                } catch {
                    print(error)
                }
                
                Logger.commonLog.info("WebSocket task received message")
                self?.receiveMessage()
            }
        }
    }

    public func send(message: URLSessionWebSocketTask.Message) {
        Logger.commonLog.info("Send WebSocketTask Message")
        webSocketTask.send(message) { error in
            guard let error = error else { return }
            self.subject.send(completion: .failure(.socketSendFailure(error)))
            Logger.commonLog.error("SocketSendFailure: \(error.localizedDescription)")
        }
    }
    
    public func close() {
        webSocketTask.cancel(with: .normalClosure, reason: nil)
        self.subject.send(completion: .finished)
        Logger.commonLog.info("Close webSocketTask")
    }

    @available(*, deprecated, message: "Legacy method, use use full-flow connect()")
    func asyncSend<D: Codable>(on endpoint: String, data: D? = nil) -> AnyPublisher<String, LemmyGenericError> {
        asyncWrapper(url: endpoint, data: data)
            .receive(on: requestQueue)
            .eraseToAnyPublisher()
    }
    
    private func asyncWrapper<D: Codable>(url: String, data: D? = nil) -> AnyPublisher<String, LemmyGenericError> {
        Future { [self] promise in
            
            guard let reqStr = makeRequestString(url: url, data: data)
            else { return promise(.failure("Can't make request string".toLemmyError)) }
            
            Logger.commonLog.info(
            """
                Current Instance: \(instanceUrl) \n
                \(reqStr)
            """)
            
            let wsMessage = createWebsocketMessage(request: reqStr)
            guard let wsTask = createWebsocketTask(instanceUrl: String.cleanUpUrl(url: instanceUrl)) else {
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
    static func cleanUpUrl(url: String) -> String {
        if url.hasPrefix("https://") {
            var url = url
            url.removeFirst(8)
            return url
        }
        
        if url.hasPrefix("www.") {
            var url = url
            url.removeFirst(4)
            return url
        }
        
        if url.hasSuffix("/") {
            var url = url
            url.removeLast()
            return url
        }
        
        return url
    }
}

// wss://dev.lemmy.ml/api/v1/ws

extension String {
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
