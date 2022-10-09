//
//  Logger.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 22.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import XCGLogger
import Combine
import Foundation

enum Logger {
    private static let appleLogDestination = "advancedLogger.systemDestination"
    private static let commonLogDestitation = "advancedLogger"

    static let common: XCGLogger = {
        $0.add(destination: systemDestination)
        $0.logAppDetails()
        return $0
    }(XCGLogger(identifier: commonLogDestitation, includeDefaultDestinations: false))
    
    static func logCombineCompletion<T: Error>(
        _ completion: Subscribers.Completion<T>,
        functionName: StaticString = #function,
        fileName: StaticString = #file,
        lineNumber: Int = #line
    ) {
        switch completion {
        case .finished:
            common.verbose(completion, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
        case .failure(let error):
            common.error(error, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
        }
    }
    
    static func log(request: URLRequest) {
        
        let urlString = request.url?.absoluteString ?? ""
        let components = NSURLComponents(string: urlString)
        
        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(components?.path ?? "")"
        let query = "\(components?.query ?? "")"
        let host = "\(components?.host ?? "")"
        
        var requestLog = "\n---------- OUT ---------->\n"
        requestLog += "\(urlString)"
        requestLog += "\n\n"
        requestLog += "\(method) \(path)?\(query) HTTP/1.1\n"
        requestLog += "Host: \(host)\n"
        for (key, value) in request.allHTTPHeaderFields ?? [:] {
            requestLog += "\(key): \(value)\n"
        }
        if let body = request.httpBody {
            let bodyString = String(data: body, encoding: .utf8)
                ?? "Can't render body; not utf8 encoded"
            requestLog += "\n\(bodyString)\n"
        }
        
        requestLog += "\n------------------------->\n"
        Logger.common.info(requestLog)
    }
    
    static func log(data: Data?, response: HTTPURLResponse?, error: Error?) {
        
        let urlString = response?.url?.absoluteString
        let components = NSURLComponents(string: urlString ?? "")
        
        let path = "\(components?.path ?? "")"
        let query = "\(components?.query ?? "")"
        
        var responseLog = "\n<---------- IN ----------\n"
        if let urlString = urlString {
            responseLog += "\(urlString)"
            responseLog += "\n\n"
        }
        
        if let statusCode = response?.statusCode {
            responseLog += "HTTP \(statusCode) \(path)?\(query)\n"
        }
        if let host = components?.host {
            responseLog += "Host: \(host)\n"
        }
        for (key, value) in response?.allHeaderFields ?? [:] {
            responseLog += "\(key): \(value)\n"
        }
        if let body = data {
            let bodyString = String(data: body, encoding: .utf8)
                ?? "Can't render body; not utf8 encoded"
            responseLog += "\n\(bodyString)\n"
        }
        if let error = error {
            responseLog += "\nError: \(error.localizedDescription)\n"
        }
        
        responseLog += "<------------------------\n"
        Logger.common.info(response)
    }

    // MARK: - Private
    private static let systemDestination: AppleSystemLogDestination = {
        $0.outputLevel = .debug
        $0.showLogIdentifier = false
        $0.showFunctionName = true
        $0.showThreadName = true
        $0.showLevel = true
        $0.showFileName = true
        $0.showLineNumber = true
        $0.showDate = true

        $0.logQueue = XCGLogger.logQueue
        return $0
    }(AppleSystemLogDestination(identifier: appleLogDestination))
}
