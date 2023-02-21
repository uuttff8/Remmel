//
//  ApiManager.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

public enum ApiManager {
    public static var requests = RequestsManager()
    public static var chainedWsCLient = ChainedWSClient()
}
