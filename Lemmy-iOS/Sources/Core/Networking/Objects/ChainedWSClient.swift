//
//  ChainedWSClient.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 25.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

final class ChainedWSClient {
    
    private var webSocketTask: URLSessionWebSocketTask
    
    private var _onConnected: (() -> Void)?
    private var _onTextMessage: ((String) -> Void)?
    private var _onError: ((Error) -> Void)?
    
    private var encoder = JSONEncoder()
    
    init(url: URL) {
        
        let urlSession = URLSession(configuration: .default)
        self.webSocketTask = urlSession.webSocketTask(with: url)
        Logger.commonLog.info("URLSession webSocketTask opened to \(url)")
    }
    
    func connect() -> ChainedWSClient {
        self.webSocketTask.resume()
        self._onConnected?()
        receiveMessages()
        ping()
        return self
    }
    
    func send<T: Codable>(_ op: String, parameters: T) {
        guard let message = self.makeRequestString(url: op, data: parameters) else { return }
        
        self.webSocketTask.send(.string(message)) { (error) in
            guard let error = error else { return }
            Logger.commonLog.error("Socket send failure: \(error)")
        }
    }
     
    func onConnected(completion: @escaping () -> Void) -> ChainedWSClient {
        self._onConnected = completion
        return self
    }
    
    func onError(completion: @escaping (Error) -> Void) -> ChainedWSClient {
        self._onError = completion
        return self
    }
    
    func onTextMessage(completion: @escaping (String) -> Void) {
        self._onTextMessage = completion
    }
    
    private func receiveMessages() {
        webSocketTask.receive { [weak self] result in
            switch result {
            case .failure(let error):
                self?._onError?(error)
                Logger.commonLog.error("SocketReceiveFailure: \(error.localizedDescription)")
            case .success(let message):
                
                guard case .string(let message) = message else { return }
                
                self?._onTextMessage?(message)
                
                Logger.commonLog.info("WebSocket task received message")
                self?.receiveMessages()
            }
        }
    }
    
    private func ping() {
        Logger.commonLog.info("PING Websocket")
        webSocketTask.sendPing { [weak self] error in
            if let error = error {
                Logger.commonLog.error("SocketPingFailure: \(error.localizedDescription)")
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
                self?.ping()
            }
        }
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
}
