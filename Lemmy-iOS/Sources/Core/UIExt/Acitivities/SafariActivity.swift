//
//  SafariActivity.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 05.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

extension UIActivity.ActivityType {
    static let openInSafari = UIActivity.ActivityType(rawValue: "openInSafari")
}

final class SafariActivity: UIActivity {

    var url: URL
    
    init(url: URL) {
        self.url = url
    }

    var activityCategory: UIActivity.Category = .action

    override var activityType: UIActivity.ActivityType {
        .openInSafari
    }

    override var activityTitle: String? {
        "Open in Safari"
    }

    override var activityImage: UIImage? {
        UIImage(systemName: "safari")?.applyingSymbolConfiguration(.init(scale: .large))
    }

    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        activityItems.contains { $0 is URL ? UIApplication.shared.canOpenURL($0 as! URL) : false }
    }

    override func perform() {
        UIApplication.shared.open(url)
        self.activityDidFinish(true)
    }
}

