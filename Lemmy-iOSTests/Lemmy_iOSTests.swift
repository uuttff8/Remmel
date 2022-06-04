//
//  Lemmy_iOSTests.swift
//  Lemmy-iOSTests
//
//  Created by uuttff8 on 9/11/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import XCTest
import Foundation
@testable import Lemmy_iOS

class LemmyiOSTests: XCTestCase {
    
    let numberOfIterations = 50

    func testHttpsCreation() throws {
        self.measure {
            guard let url = URL(string: "wss://dev.lemmy.ml/api/v3/ws") else {
                return
            }
            for _ in (0..<numberOfIterations) {

                let urlSession = URLSession(configuration: .default)
                let ws = urlSession.dataTask(with: url)
                
                ws.resume()
            }
        }
    }
    
    func testWebsocketCreation() throws {
        self.measure {
            guard let url = URL(string: "wss://dev.lemmy.ml/api/v3/ws") else {
                return
            }
            for _ in (0..<numberOfIterations) {
                let urlSession = URLSession(configuration: .default)
                let ws = urlSession.webSocketTask(with: url)
                
                ws.sendPing { _ in }
                
                ws.resume()
            }
        }
    }
    
}
