//
//  RequestsManager.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

// MARK: - Error -
struct ApiErrorResponse: Codable, Equatable {
    let error: String
}

class RequestsManager {
    
    struct ApiResponse<T: Codable>: Codable {
        let op: String
        let data: T
    }
    
    let wsClient: WSLemmyClient
    let httpClient = HttpLemmyClient()
    let decoder = LemmyJSONDecoder()
    
    private let requestQueue = DispatchQueue(label: "Lemmy-iOS.RequestQueue")
        
    init?(instanceUrl: String) {
        guard let url = URL(string: "wss://" + instanceUrl + "/api/v1/ws") else {
            return nil
        }
        wsClient = WSLemmyClient(url: url)
    }
    
    func asyncRequestDecodable<Req: Codable, Res: Codable>(
        path: String,
        parameters: Req? = nil,
        parsingFromDataKey rootKey: Bool = true
    ) -> AnyPublisher<Res, LemmyGenericError> {
        
        wsClient.asyncSend(on: path, data: parameters)
            .receive(on: requestQueue)
            .flatMap { (outString: String) in
                self.asyncDecode(data: outString.data(using: .utf8)!)
            }.eraseToAnyPublisher()
    }
        
    func _uploadImage<Res: Codable>(
        path: String,
        image: UIImage,
        filename: String,
        completion: @escaping ((Result<Res, LemmyGenericError>) -> Void)
    ) {
        httpClient.uploadImage(url: path, image: image, filename: filename) { (result) in
            switch result {
            case .failure(let why):
                completion(.failure(why))
            case .success(let outData):
                
                do {
                    let decoded = try self.decoder.decode(Res.self, from: outData)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(.string("Failed to decode from \(error)")))
                }
            }
        }
    }
        
    private func asyncDecode<D: Codable>(
        data: Data,
        parsingFromData: Bool = true
    ) -> AnyPublisher<D, LemmyGenericError> {
        
        Future { promise in
            if parsingFromData {
                do {
                    let apiResponse = try self.decoder.decode(ApiResponse<D>.self, from: data)
                    let normalResponse = apiResponse.data
                    promise(.success(normalResponse))
                } catch {
                    
                    // idk how to extract this and line 96 to function
                    do {
                        let errorResponse = try self.decoder.decode(ApiErrorResponse.self, from: data)
                        promise(.failure(.string(errorResponse.error)))
                    } catch {
                        promise(.failure("Can't decode api response: \n \(error)".toLemmyError))
                    }
                }
                
            } else {
                
                do {
                    let apiResponse = try self.decoder.decode(D.self, from: data)
                    promise(.success(apiResponse))
                } catch {
                    do {
                        let errorResponse = try self.decoder.decode(ApiErrorResponse.self, from: data)
                        promise(.failure(.string(errorResponse.error)))
                    } catch {
                        promise(.failure("Can't decode api response: \n \(error)".toLemmyError))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
}

extension String: Error {
    public var errorDescription: String { return self }
}
