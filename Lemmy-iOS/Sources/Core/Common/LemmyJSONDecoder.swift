//
//  LemmyJSONDecoder.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 07.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

class LemmyJSONDecoder: JSONDecoder {

    override func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.lemmyDateFormat
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        decoder.dateDecodingStrategy = .formatted(dateFormatter)        
        return try decoder.decode(T.self, from: data)
    }
}
