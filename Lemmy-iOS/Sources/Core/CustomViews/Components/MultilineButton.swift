//
//  MultilineButton.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 05.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

/// Drop-in replacement for multiline button containing only a label
class LabelControl: UIControl {

    let titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override var isHighlighted: Bool {
        didSet {
            backgroundColor = backgroundColor?.withAlphaComponent(isHighlighted ? 0.7 : 1.0)
            titleLabel.textColor = titleLabel.textColor.withAlphaComponent(isHighlighted ? 0.7 : 1.0)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
