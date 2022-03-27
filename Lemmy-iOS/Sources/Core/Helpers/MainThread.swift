//
//  MainThread.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 3/27/22.
//  Copyright © 2022 Anton Kuzmin. All rights reserved.
//

import Foundation

func onMainThread<Input>(_ handler: @escaping (Input) -> Void) -> (Input) -> Void {
    return { (input: Input) in
        guard !Thread.isMainThread else {
            return handler(input)
        }

        DispatchQueue.main.async(execute: { handler(input) })
    }
}
