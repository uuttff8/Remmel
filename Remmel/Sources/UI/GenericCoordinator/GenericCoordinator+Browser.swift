//
//  GenericCoordinator+Browser.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 08/10/2022.
//  Copyright © 2022 Anton Kuzmin. All rights reserved.
//

import UIKit
import SafariServices

extension GenericCoordinator {
    func goToBrowser(with url: URL, inApp: Bool = true) {
        // https://stackoverflow.com/a/35458932
        if ["http", "https"].contains(url.scheme?.lowercased() ?? ""), inApp {
            // Can open with SFSafariViewController
            let safariVc = SFSafariViewController(url: url)
            safariVc.delegate = self
            rootViewController.present(safariVc, animated: true, completion: nil)
        } else {
            // Scheme is not supported or no scheme is given, use openURL
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
