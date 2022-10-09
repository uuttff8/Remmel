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

final class SafariShareActivity: UIActivity {

    private let url: URL
    
    init(url: URL) {
        self.url = url
    }

    var activityCategory: UIActivity.Category = .action

    override var activityType: UIActivity.ActivityType {
        .openInSafari
    }

    override var activityTitle: String? {
        "activity-open-in-safari".localized
    }

    override var activityImage: UIImage? {
        UIImage(systemName: "safari")?.applyingSymbolConfiguration(.init(scale: .large))
    }

    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        guard activityItems.contains(where: { $0 is URL }) else {
            return false
        }
        return true
    }

    override func perform() {
        UIApplication.shared.open(url)
        activityDidFinish(true)
    }
}
