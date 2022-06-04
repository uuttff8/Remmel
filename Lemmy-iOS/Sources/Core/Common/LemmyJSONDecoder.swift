//
//  LemmyJSONDecoder.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 07.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

class LemmyJSONDecoder: JSONDecoder {

    // if you touch date things, app response may break  on real devices
    override func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.lemmyDateFormat
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        decoder.dateDecodingStrategy = .custom({ decoder -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            
            let formatters = [Date.lemmyDateFormat, Date.lemmyDateFormatZero].map { (format: String) -> DateFormatter in
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = format
                return formatter
            }
            
            for formatter in formatters {
                
                if let date = formatter.date(from: dateStr) {
                    return date
                }
            }
            
            throw DateError.invalidDate
        })
        return try decoder.decode(T.self, from: data)
    }
}

class LMMJSONEncoder: JSONEncoder {
    override init() {
        super.init()
        
        let dateFmt = DateFormatter()
        dateFmt.dateFormat = Date.lemmyDateFormat
        dateFmt.locale = Locale(identifier: "en_US_POSIX")
        
        self.dateEncodingStrategy = .formatted(dateFmt)
    }
}

enum DateError: Error {
    case invalidDate
}
