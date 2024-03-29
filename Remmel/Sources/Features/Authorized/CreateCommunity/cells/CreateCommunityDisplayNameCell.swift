//
//  CreateCommunityDisplayNameCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 29.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CreateCommunityDisplayNameCell: UITableViewCell {
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Display name"
        return tf
    }()

    init() {
        super.init(style: .default, reuseIdentifier: String(describing: Self.self))

        self.contentView.addSubview(nameTextField)
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        nameTextField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
