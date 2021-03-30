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
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testHttpsCreation() throws {
        self.measure {
            for _ in (0..<numberOfIterations) {
                
                let urlSession = URLSession(configuration: .default)
                let ws = urlSession.dataTask(with: URL(string: "https://dev.lemmy.ml/api/v1/")!)
                
                ws.resume()
            }
        }
    }
    
    func testWebsocketCreation() throws {
        self.measure {
            for _ in (0..<numberOfIterations) {
                let urlSession = URLSession(configuration: .default)
                let ws = urlSession.webSocketTask(with: URL(string: "wss://dev.lemmy.ml/api/v3/ws")!)
                
                ws.sendPing { _ in }
                
                ws.resume()
            }
        }
    }
    
}
