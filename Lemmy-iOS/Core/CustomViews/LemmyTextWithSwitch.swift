//
//  LemmyTextWithSwitch.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/15/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class LemmyLabelWithSwitchCell: UITableViewCell {

    let customView = LemmyLabelWithSwitch()

    init() {
        super.init(style: .default, reuseIdentifier: String(describing: Self.self))

        self.contentView.addSubview(customView)

        customView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LemmyLabelWithSwitch: UIView {
    let checkFieldStackView = UIStackView()

    var checkText: String = "YOUR CHECK TEXT HERE" {
        didSet {
            checkTextLabel.text = checkText
        }
    }

    lazy var checkTextLabel: UILabel = {
        let lbl = UILabel()
        return lbl
    }()

    lazy var switcher: UISwitch = {
        let swt = UISwitch()
        return swt
    }()

    init() {
        super.init(frame: .zero)

        self.addSubview(checkFieldStackView)

        checkFieldStackView.axis = .horizontal
        checkFieldStackView.addArrangedSubview(checkTextLabel)
        checkFieldStackView.addArrangedSubview(switcher)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        checkFieldStackView.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalToSuperview()
        }

        self.snp.makeConstraints { (make) in
            make.height.equalTo(switcher.intrinsicContentSize.height)
        }
    }
}
