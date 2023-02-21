//
//  Date+Ext.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 13.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

public extension Date {
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }

    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
}

public extension Date {
    static let lemmyDateFormat     = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
    static let lemmyDateFormatZero = "yyyy-MM-dd'T'HH:mm:ss"
    
    static func toLemmyDate(str: String?) -> Date {
        guard let str = str else {
            return Date()
        }
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate, .withFractionalSeconds, .withTime, .withColonSeparatorInTime]
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.date(from: str) ?? Date()
    }
    
    func toRelativeDate() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
