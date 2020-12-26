//
//  ImageControl.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 25.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

// Drop-in replacement for button containing only image
class ImageControl: UIControl {

    let innerImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(innerImageView)
        
        innerImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override var isHighlighted: Bool {
        didSet {
            backgroundColor = backgroundColor?.withAlphaComponent(isHighlighted ? 0.7 : 1.0)
            innerImageView.tintColor = innerImageView.tintColor.withAlphaComponent(isHighlighted ? 0.7 : 1.0)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
