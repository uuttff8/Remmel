//
//  SettingsInputWithImageTableViewCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 25.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol SettingsInputWithImageCellDelegate: AnyObject {
    func settingsCellDidTappedToIcon(
        _ cell: SettingsInputWithImageTableViewCell
    )
}

final class SettingsInputWithImageTableViewCell: SettingsTableViewCell<SettingsInputWithImageCellView> {
    weak var delegate: SettingsInputWithImageCellDelegate?
    var uniqueIdentifier: UniqueIdentifierType?

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        self.selectionStyle = .none
        self.elementView.onIconImageTap = { [weak self] in
            guard let self = self else { return }

            self.delegate?.settingsCellDidTappedToIcon(self)
        }
    }
}
