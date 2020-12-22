//
//  Logger.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 22.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import XCGLogger

class Logger {
    private static let appleLogDestination = "advancedLogger.systemDestination"
    private static let commonLogDestitation = "advancedLogger"
    
    private static let systemDestination = with(AppleSystemLogDestination(identifier: appleLogDestination) ) {
        $0.outputLevel = .debug
        $0.showLogIdentifier = false
        $0.showFunctionName = true
        $0.showThreadName = true
        $0.showLevel = true
        $0.showFileName = true
        $0.showLineNumber = true
        $0.showDate = true
        
        $0.logQueue = XCGLogger.logQueue
    }
    
    static let commonLog = with(XCGLogger(identifier: commonLogDestitation, includeDefaultDestinations: false)) {
        $0.add(destination: systemDestination)
        $0.logAppDetails()
    }
}
