//
//  SettingsInputWithImageTableViewCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 25.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMFoundation

protocol SettingsInputWithImageCellDelegate: AnyObject {
    func settingsCellDidTappedToIcon(
        _ cell: SettingsInputWithImageTableViewCell
    )
    
    func settingsCellWithImageDidEnterText(
        elementView: SettingsInputWithImageTableViewCell,
        didReportTextChange text: String?
    )
}

final class SettingsInputWithImageTableViewCell: SettingsTableViewCell<SettingsInputWithImageCellView> {
    weak var delegate: SettingsInputWithImageCellDelegate?
    var uniqueIdentifier: UniqueIdentifierType?
    
    var urlState: SettingsInputWithImageCellView.UrlState {
        get { elementView.urlState }
        set { elementView.urlState = newValue }
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        self.selectionStyle = .none
        self.elementView.onIconImageTap = {
            [weak self] in

            guard let self = self else {
                return
            }

            self.delegate?.settingsCellDidTappedToIcon(self)
        }
        
        self.elementView.onEnteredText = {
            [weak self] text in

            guard let self = self else {
                return
            }

            self.delegate?.settingsCellWithImageDidEnterText(elementView: self, didReportTextChange: text)
        }
    }
}
