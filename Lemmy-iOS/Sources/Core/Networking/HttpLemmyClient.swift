//
//  RestLemmy.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 24.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

private protocol HTTPClientProvider {
    func getAuth(url: URL, completion: @escaping ((Result<Data, Error>) -> Void))
    func postAuth(url: String, bodyObject: Codable?, completion: @escaping (Result<Data, Error>) -> Void)
    func uploadImage(
        url: String,
        image: UIImage,
        filename: String,
        completion: @escaping (Result<Data, LemmyGenericError>) -> Void
    )
//    func genericRequest(url: URL,
//                        method: String,
//                        bodyObject: [String: Any]?,
//                        completion: @escaping (Result<Data, Error>) -> Void)
}

final class HttpLemmyClient: HTTPClientProvider {
    func getAuth(url: URL, completion: @escaping ((Result<Data, Error>) -> Void)) {
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
                   delegate: nil,
                   delegateQueue: OperationQueue.current)
            .dataTask(with: request) { (data: Data?, _: URLResponse?, error: Error?) in
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

        guard let jsonBody = try? JSONSerialization.data(withJSONObject: bodyObject?.dictionary ?? [], options: [])
        else { return }

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
            .dataTask(with: request) { (data: Data?, _: URLResponse?, _: Error?) in
                if let data = data {
                    completion(.success(data))
                }
            }.resume()
    }

    func uploadImage(
        url: String,
        image: UIImage,
        filename: String,
        completion: @escaping (Result<Data, LemmyGenericError>) -> Void
    ) {
        guard let url = URL(string: url) else { return }
        guard let jwt = LoginData.shared.jwtToken else {
            Logger.commonLog.error("JWT token is not provided")
            return
        }
        
        let boundary = generateBoundary()

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let httpBody = createBody(imageToUpload: image, filename: filename, boundary: boundary)

        request.httpBody = httpBody

        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.httpAdditionalHeaders = [ "Cookie": "\(jwt)" ]

        URLSession(configuration: config,
                   delegate: INetworkDelegate(),
                   delegateQueue: OperationQueue.current)
            .dataTask(with: request) { (data: Data?, _: URLResponse?, error: Error?) in
                if let data = data {
                    Logger.commonLog.info(String(data: data, encoding: .utf8))
                    completion(.success(data))
                } else if let error = error {
                    completion(.failure(.string(error as! String)))
                }
            }.resume()
    }

    private func createBody(
        imageToUpload: UIImage,
        filename: String,
        boundary: String
    ) -> Data {
        var body = Data()
        
        let filenameExt = filename.fileExtension
        
        let mimetype = "image/\(filenameExt)"
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
}

private class INetworkDelegate: NSObject, URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        print("\(session) \(task) waiting")
    }
}

private extension String {

    var fileName: String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }

    var fileExtension: String {
        return URL(fileURLWithPath: self).pathExtension
    }
}

private extension Data {

    /// Append string to Data
    ///
    /// Rather than littering my code with calls to `data(using: .utf8)`
    ///  to convert `String` values to `Data`, this wraps it in a nice convenient little extension to Data.
    ///  This defaults to converting using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `Data`.
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}
