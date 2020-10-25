//
//  RestLemmy.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 24.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

private protocol HTTPClientProvider {
    func getAuth(url: URL, completion: @escaping ((Result<Data, Error>) -> ()))
    func postAuth(url: String, bodyObject: Codable?, completion: @escaping (Result<Data, Error>) -> Void)
    func genericRequest(url: URL,
                        method: String,
                        bodyObject: [String: Any]?,
                        completion: @escaping (Result<Data, Error>) -> Void)
}

final class HttpLemmyClient: HTTPClientProvider {
    func getAuth(url: URL, completion: @escaping ((Result<Data, Error>) -> ())) {
        guard let jwt = LoginData.shared.jwtToken else {
            print("JWT token is not provided")
            return
        }
        
        let config = URLSessionConfiguration.ephemeral
        config.waitsForConnectivity = true
        
        config.httpAdditionalHeaders = [ "Cookie": "\(jwt)",
                                         "Accept": "application/json",
                                         "Content-Type": "application/json" ]
        
        let request = URLRequest(url: url)
        
        URLSession(configuration: config,
                   delegate:nil,
                   delegateQueue: OperationQueue.current)
            .dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                if let data = data {
                    completion(.success(data))
                } else if let error = error {
                    completion(.failure(error))
                }
            }.resume()
    }
    
    func postAuth(
        url: String,
        bodyObject: Codable?,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        guard let url = URL(string: url) else { return }
        guard let jwt = LoginData.shared.jwtToken else {
            print("JWT token is not provided")
            return
        }
        
        guard let jsonBody = try? JSONSerialization.data(withJSONObject: bodyObject?.asDictionary() ?? [], options: []) else { return }
        
        let config = URLSessionConfiguration.ephemeral
        config.waitsForConnectivity = true
        config.httpAdditionalHeaders = [ "Cookie": "\(jwt)",
                                         "Accept": "application/json",
                                         "Content-Type": "application/json"]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonBody
        
        URLSession(configuration: config,
                   delegate: INetworkDelegate(),
                   delegateQueue: OperationQueue.current)
            .dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                if let data = data {
                    completion(.success(data))
                }
            }.resume()
    }
    
    func uploadImage(
        url: String,
        image: UIImage,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        
        guard let url = URL(string: url) else { return }
        guard let jwt = LoginData.shared.jwtToken else {
            print("JWT token is not provided")
            return
        }
        let boundary = generateBoundary()
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? createBody(imageToUpload: image, boundary: boundary) else {
            completion(.failure("Failed to create request body"))
            return
        }
        
        request.httpBody = httpBody
        
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.httpAdditionalHeaders = [ "Cookie": "\(jwt)" ]
        
        URLSession(configuration: config,
                   delegate: INetworkDelegate(),
                   delegateQueue: OperationQueue.current)
            .dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                if let data = data {
                    completion(.success(data))
                } else if let error = error {
                    completion(.failure(error))
                }
            }.resume()
        
    }
    
    private func createBody(
        imageToUpload: UIImage,
        boundary: String
    ) throws -> Data {
        var body = Data()
        
        let filename = "file"
        let mimetype = "image/png"
        let filePathKey = "images[]"
        guard let imageData = imageToUpload.jpegData(compressionQuality: 1) else { return Data() }
        
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n")
        body.append("Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageData)
        body.append("\r\n")
        
        body.append("--\(boundary)--\r\n")
        return body
    }
    
    private func generateBoundary() -> String {
        "Boundary-\(UUID().uuidString)"
    }
    
    func genericRequest(
        url: URL,
        method: String,
        bodyObject: [String: Any]?,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        guard let jwt = LoginData.shared.jwtToken else {
            print("JWT token is not provided")
            return
        }
        
        let config = URLSessionConfiguration.ephemeral
        config.waitsForConnectivity = true
        config.httpAdditionalHeaders = [ "Cookie": "\(jwt)",
                                         "Accept": "application/json",
                                         "Content-Type": "application/json"]
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        if let bodyObject = bodyObject {
            guard let jsonBody = try? JSONSerialization.data(withJSONObject: bodyObject, options: []) else { return }
            request.httpBody = jsonBody
        }
        
        URLSession(configuration: config,
                   delegate: INetworkDelegate(),
                   delegateQueue: OperationQueue.current)
            .dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                if let data = data {
                    completion(.success(data))
                }
            }.resume()
    }
    
    func deleteRequest(url: URL, method: String, completion: @escaping (Result<(), Error>) -> Void) {
        guard let jwt = LoginData.shared.jwtToken else {
            print("JWT token is not provided")
            return
        }
        
        let config = URLSessionConfiguration.ephemeral
        config.waitsForConnectivity = true
        config.httpAdditionalHeaders = [ "Cookie": "\(jwt)",
                                         "Accept": "application/json",
                                         "Content-Type": "application/json" ]
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        URLSession(configuration: config,
                   delegate: INetworkDelegate(),
                   delegateQueue: OperationQueue.current)
            .dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                if let response = response as? HTTPURLResponse {
                    
                    // 204 No Content
                    if response.statusCode == 204 {
                        completion(.success(()))
                    } else if let error = error {
                        completion(.failure(error))
                    }
                    
                }
            }.resume()
    }
}

private class INetworkDelegate: NSObject, URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        print("\(session) \(task) waiting")
    }
}

private extension Data {
    
    /// Append string to Data
    ///
    /// Rather than littering my code with calls to `data(using: .utf8)` to convert `String` values to `Data`, this wraps it in a nice convenient little extension to Data. This defaults to converting using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `Data`.
    
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}
