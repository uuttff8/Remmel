//
//  Assembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 09.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol Assembly {
    associatedtype ViewController: UIViewController
    
    func makeModule() -> ViewController
}
