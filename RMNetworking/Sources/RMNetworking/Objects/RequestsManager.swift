//
//  RequestsManager.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine
import RMFoundation

// MARK: - Error -
struct ApiErrorResponse: Codable, Equatable {
    let error: String
}

public class RequestsManager {
    
    public struct ApiResponse<T: Codable>: Codable {
        let op: String
        let data: T
    }
        
    public let wsClient: WSLemmyClient
    public let httpClient = HttpLemmyClient()
    public let decoder = LemmyJSONDecoder()
    
    private let requestQueue = DispatchQueue(label: "Lemmy-iOS.RequestQueue")
        
    public init(instanceUrl: InstanceUrl) {
        // swiftlint:disable:next force_unwrapping
        wsClient = WSLemmyClient(url: URL(string: instanceUrl.wssLink)!)
    }
    
    /// use only when auth
    convenience init() {
        self.init(instanceUrl: LemmyShareData.shared.authedInstanceUrl)
    }
    
    public func asyncRequestDecodable<Req: Codable, Res: Codable>(
        path: String,
        parameters: Req? = nil,
        parsingFromDataKey rootKey: Bool = true
    ) -> AnyPublisher<Res, LemmyGenericError> {
        
        debugPrint("Trying to connect to \(self.wsClient.instanceUrl) instance")
        
        return wsClient.asyncSend(on: path, data: parameters)
            .receive(on: requestQueue)
            .flatMap { (outString: String) in
                // swiftlint:disable:next force_unwrapping
                self.asyncDecode(data: outString.data(using: .utf8)!)
            }.eraseToAnyPublisher()
    }
        
    public func _uploadImage<Res: Codable>(
        path: String,
        image: UIImage,
        filename: String,
        completion: @escaping ((Result<Res, LemmyGenericError>) -> Void)
    ) {
        httpClient.uploadImage(url: path, image: image, filename: filename) { result in
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
                } catch let responseError {
                    
                    debugPrint(String(describing: D.self) + " " + responseError.localizedDescription)
                    
                    do {
                        let errorResponse = try self.decoder.decode(ApiErrorResponse.self, from: data)
                        promise(.failure(.string(errorResponse.error)))
                    } catch {
                        promise(.failure(LemmyGenericError.string("Can't decode api response: \n \(responseError)")))
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
                        promise(.failure(LemmyGenericError.string("Can't decode api response: \n \(error)")))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
}

extension String: Error {
    public var errorDescription: String { return self }
}

public extension String {
    
    static func makePathToPictrs(_ pic: String) -> String {
        let host = LemmyShareData.shared.authedInstanceUrl.rawHost
        return "https://\(host)/pictrs/image/\(pic)"
    }
}

extension Data {
    var prettyPrintedJSONString: NSString? { // NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        else { return nil }

        return prettyPrintedString
    }
}
