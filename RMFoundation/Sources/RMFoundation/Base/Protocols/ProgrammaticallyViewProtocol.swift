//
//  ProgrammaticallyInitializableView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 09.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol ProgrammaticallyViewProtocol: AnyObject {
    func setupView()
    func addSubviews()
    func makeConstraints()
}

extension ProgrammaticallyViewProtocol where Self: UIView {
    func setupView() {
        // Empty body to make method optional
    }

    func addSubviews() {
        // Empty body to make method optional
    }

    func makeConstraints() {
        // Empty body to make method optional
    }
}
