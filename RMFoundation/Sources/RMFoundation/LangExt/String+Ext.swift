//
//  String+Ext.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 19.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

public extension String {
    func removeNewLines() -> String {
        trimmingCharacters(in: .newlines)
    }
    
    func trim() -> String {
        trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    var encodeUrl: String {
        // swiftlint:disable:next force_unwrapping
        addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    
    var decodeUrl: String {
        // swiftlint:disable:next force_unwrapping
        removingPercentEncoding!
    }
}

public extension String {
    
    var localized: String {
        // swiftlint:disable:next nslocalizedstring_key
        NSLocalizedString(self, comment: "\(self)_comment")
    }
    
    func localizedMany(_ args: [CVarArg]) -> String {
        localized(args)
    }
    
    func localized(_ args: CVarArg...) -> String {
        String(format: localized, args)
    }
}
