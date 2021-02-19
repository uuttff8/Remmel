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
    var onError: ((Error) -> Void)? { get set }
    
    func send<T: Codable>(_ op: String, parameters: T)
    func send<T: Codable>(_ op: LMMUserOperation, parameters: T)
    
    func close()
    
    func decodeWsType<T: Codable>(_ type: T.Type, data: Data) -> T?
}

final class ChainedWSClient: WSClientProtocol {
        
    private var webSocketTask: URLSessionWebSocketTask?
    private let wsEndpoint: URL
    
    var onConnected: (() -> Void)?
    var onTextMessage: MessageDynamicValue = MessageDynamicValue(("", Data()))
    var onError: ((Error) -> Void)?
    
    private var encoder = JSONEncoder()
    private let decoder = LemmyDecoder()
    
    private let reconnecting: Bool
    private let nwMonitor = NWPathMonitor()
    
    private var cancellables = Set<AnyCancellable>()
    
    init?(urlString: String, reconnecting: Bool = true) {
        self.reconnecting = reconnecting
        
        guard let url = String.createInstanceFullUrl(instanceUrl: urlString) else { return nil }
        self.wsEndpoint = url
        
        let urlSession = URLSession(configuration: .default)
        self.webSocketTask = urlSession.webSocketTask(with: url)
        Logger.commonLog.info("URLSession webSocketTask opened to \(url)")
    }
    
    @discardableResult
    func connect() -> WSClientProtocol {
        Logger.commonLog.info("Open connection at \(LemmyShareData.shared.currentInstanceUrl)")
        self.webSocketTask?.resume()
        self.onConnected?()
        receiveMessages()
        ping()
        return self
    }
    
    func send<T: Codable>(_ op: String, parameters: T) {
        guard let message = self.makeRequestString(url: op, data: parameters) else { return }
        
        Logger.commonLog.info(message)
        
        self.webSocketTask?.send(.string(message)) { (error) in
            guard let error = error else { return }
            Logger.commonLog.error("Socket send failure: \(error)")
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
        Logger.commonLog.info("Trying to reconnect at \(LemmyShareData.shared.currentInstanceUrl)")
        
        if self.reconnecting {
//            if self.nwMonitor.currentPath.status == .satisfied {
                let urlSession = URLSession(configuration: .default)
                self.webSocketTask = urlSession.webSocketTask(with: self.wsEndpoint)
                self.webSocketTask?.resume()
                receiveMessages()
//            } else {
//                self._onError?("No internet")
//            }
        }
    }
    
    func decodeWsType<T: Codable>(_ type: T.Type, data: Data) -> T? {
        //swiftlint:disable:next force_try
        /*guard*/ let data = try! LemmyJSONDecoder().decode(
            RequestsManager.ApiResponse<T>.self,
            from: data
        ) /*else { return nil }*/
        
        return data.data
    }
    
    private func receiveMessages() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                self?.onError?(error)
                Logger.commonLog.error("SocketReceiveFailure: \(error.localizedDescription)")
            case .success(let message):
                
                guard case .string(let message) = message else { return }
                guard let messageData = message.data(using: .utf8) else { return }
                
                self?.decoder.decode(data: messageData) { (res) in
                    switch res {
                    case .success(let operation):
                        self?.onTextMessage.value = (operation, messageData)
                    case .failure(let error):
                        Logger.commonLog.error(error.localizedDescription)
                    }
                }
                
                Logger.commonLog.info("WebSocket task received message \(message)")
                self?.receiveMessages()
            }
        }
    }
    
    private func ping() {
        Logger.commonLog.info("PING Websocket")
        webSocketTask?.sendPing { [weak self] error in
            if let error = error {
                Logger.commonLog.error("SocketPingFailure: \(error.localizedDescription)")
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
}
