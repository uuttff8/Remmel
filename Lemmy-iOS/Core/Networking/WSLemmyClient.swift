//
//  WSLemmy.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/11/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class WSLemmyClient {
    func send<D: Codable>(on endpoint: String, data: D? = nil, completion: @escaping (String) -> Void) {
        wrapper(url: endpoint, data: data, completion: completion)
    }
    
    func wrapper<D: Codable>(url: String, data: D? = nil, completion: @escaping (String) -> Void) {
        let reqStr: String
        if let data = data {
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let orderJsonData = try! encoder.encode(data)
            let sss = String(data: orderJsonData, encoding: .utf8)!
            
            reqStr = """
            {"op": "\(url)","data": \(sss)}
            """
        } else {
            reqStr = """
            {"op":"\(url)","data":{}}
            """
        }
        
        print(reqStr)
        
        let wsTask = URLSessionWebSocketTask.Message.string(reqStr)
        let urlSession = URLSession(configuration: .default)
        let ws = urlSession.webSocketTask(with: URL(string: "wss://dev.lemmy.ml/api/v1/ws")!)
        ws.resume()
        
        ws.send(wsTask) { (error) in
            if let error = error {
                print("WebSocket couldn’t send message because: \(error)")
            }
        }
        
        ws.receive { (res) in
            switch res {
            case .failure(let error):
                print(error)
            case .success(let messageType):
                switch messageType {
                case .string(let outString):
                    completion(outString)
                case .data(_):
                    break
//                    print(outData)
                @unknown default:
                    break
                }
            }
        }
    }
}
