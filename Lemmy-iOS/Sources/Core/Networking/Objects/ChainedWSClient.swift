//
//  ChainedWSClient.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 25.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation
import Network
import Combine

protocol WSClientProtocol: AnyObject {
    func connect() -> WSClientProtocol

    var onConnected: (() -> Void)? { get set }
    var onTextMessage: MessageDynamicValue { get set }
    var onError: ErrorDynamicValue { get set }
    
    func send<T: Codable>(_ op: String, parameters: T)
    func send<T: Codable>(_ op: LMMUserOperation, parameters: T)
    
    func reconnectIfNeeded()
    
    func close()
    
    func decodeWsType<T: Codable>(_ type: T.Type, data: Data) -> T?
}

final class ChainedWSClient: NSObject, WSClientProtocol {
        
    private var webSocketTask: URLSessionWebSocketTask?
    private var wsEndpoint: URL? {
        URL(string: LemmyShareData.shared.currentInstanceUrl?.wssLink ?? "")
    }
    
    var onConnected: (() -> Void)?
    var onTextMessage: MessageDynamicValue = MessageDynamicValue(("", Data()))
    var onError: ErrorDynamicValue = ErrorDynamicValue("")
    
    private var encoder = JSONEncoder()
    private let decoder = LemmyDecoder()
    
    private let reconnecting: Bool
    private var isConnected = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(reconnecting: Bool = true) {
        self.reconnecting = reconnecting
        super.init()
        
        self.webSocketTask = self.getNewWsTask()
        Logger.common.info("URLSession webSocketTask opened to \(wsEndpoint as Any)")
    }
    
    @discardableResult
    func connect() -> WSClientProtocol {
        Logger.common.info("Open connection at \(LemmyShareData.shared.currentInstanceUrl?.httpLink ?? "NOT FOUND")")
        self.webSocketTask?.resume()
        self.onConnected?()
        receiveMessages()
        ping()
        return self
    }
    
    func send<T: Codable>(_ op: String, parameters: T) {
        guard let message = self.makeRequestString(url: op, data: parameters) else { return }
        
        Logger.common.info("ws request to \(LemmyShareData.shared.currentInstanceUrl?.httpLink ?? "NOT FOUND")")
        Logger.common.info(message)
        self.reconnectIfNeeded()
        
        self.webSocketTask?.send(.string(message)) { (error) in
            guard let error = error else { return }
            Logger.common.error("Socket send failure: \(error)")
            self.reconnectIfNeeded()
        }
    }
    
    func send<T: Codable>(_ op: LMMUserOperation, parameters: T) {
        self.send(op.rawValue, parameters: parameters)
    }
    
    func close() {
        self.webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
    
    func reconnectIfNeeded() {
                
        if self.webSocketTask?.state != .running
            && !self.isConnected
            && self.reconnecting {
            
            Logger.common.info("Trying to reconnect at \(LemmyShareData.shared.currentInstanceUrl?.wssLink ?? "NOT FOUND")")
            
            self.webSocketTask = getNewWsTask()
            self.webSocketTask?.resume()
            receiveMessages()
        }
    }
    
    func decodeWsType<T: Codable>(_ type: T.Type, data: Data) -> T? {
        do {
            let data = try LemmyJSONDecoder().decode(
               RequestsManager.ApiResponse<T>.self,
               from: data
           )
            
            return data.data
        } catch {
            Logger.common.error("Failed to parse \(RequestsManager.ApiResponse<T>.self)")
            Logger.common.error(error)
            return nil
        }
    }
    
    private func receiveMessages() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                self?.onError.value = error
                Logger.common.error("SocketReceiveFailure: \(error.localizedDescription)")
                self?.webSocketTask?.cancel(with: .goingAway, reason: nil)
                
                self?.reconnectIfNeeded()
            case .success(let message):
                
                guard case .string(let message) = message else { return }
                guard let messageData = message.data(using: .utf8) else { return }
                
                self?.decoder.decode(data: messageData) { (res) in
                    switch res {
                    case .success(let operation):
                        self?.onTextMessage.value = (operation, messageData)
                    case .failure(let error):
                        Logger.common.error(error.localizedDescription)
                    }
                }
                
                Logger.common.info("WebSocket task received message \(message)")
                self?.receiveMessages()
            }
        }
    }
    
    private func ping() {
        Logger.common.info("PING Websocket")
        webSocketTask?.sendPing { [weak self] error in
            if let error = error {
                Logger.common.error("SocketPingFailure: \(error.localizedDescription)")
                self?.reconnectIfNeeded()
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
                self?.ping()
            }
        }
    }
    
    private func makeRequestString<T: Codable>(url: String, data: T?) -> String? {
        if let data = data {
            
            encoder.outputFormatting = .prettyPrinted
            guard let orderJsonData = try? encoder.encode(data)
            else {
                Logger.common.error("failed to encode data \(#file) \(#line)")
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
    
    private func getNewWsTask() -> URLSessionWebSocketTask? {
        guard let endpoint = wsEndpoint else {
            Logger.common.alert("Endpoint for WebSocket not found")
            return nil
        }
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForResource = 300
        config.waitsForConnectivity = true
        let sess = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.current)
        return sess.webSocketTask(with: endpoint)
    }
}

extension ChainedWSClient: URLSessionWebSocketDelegate {
    func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didOpenWithProtocol protocol: String?
    ) {
        self.isConnected = true
    }
    func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
        reason: Data?
    ) {
        self.isConnected = false
    }
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didCompleteWithError: Error?
    ) {
        self.isConnected = false
    }
}
