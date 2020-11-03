//
//  CommunityContentTypePickerCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 03.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CommunityContentTypePickerCell: UITableViewCell {
    
    var presentPicker: ((UIAlertController) -> Void)?
    var onSelectedContentType: ((LemmySortType) -> Void)?
    
    let contentTypePicker = LemmyImageTextTypePicker()
    
    init() {
        super.init(style: .default, reuseIdentifier: String(describing: Self.self))
        
        selectionStyle = .none
        
        contentView.addSubview(contentTypePicker)
        
        contentTypePicker.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
        
        contentTypePicker.addTap {
            self.presentPicker?(self.contentTypePicker.configuredAlert)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LemmyImageTextTypePicker: UIView {
    
    lazy var configuredAlert: UIAlertController = {
        let control = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        caseArray.forEach { (enumCase) in
            
            let action = UIAlertAction(
                title: enumCase.label,
                style: .default,
                handler: { _ in
                    self.onSelectedCase(enumCase: enumCase)
                })
            
            control.addAction(action)
        }
        control.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        
        return control
    }()
    
    private var caseArray = LemmySortType.allCases
    
    var typeLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14, weight: .semibold)
        lbl.text = LemmySortType.active.uppercasedLabel
        lbl.textColor = .lightGray
        return lbl
    }()
    
    let typeImage: UIImageView = {
        let iv = UIImageView()
        let image = UIImage(systemName: "checkmark.seal.fill")!
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        iv.image = image
        return iv
    }()
    
    init() {
        super.init(frame: .zero)
        
        [typeImage, typeLabel].forEach { (view) in
            addSubview(view)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        typeImage.snp.makeConstraints { (make) in
            make.size.equalTo(20)
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        typeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(typeImage)
            make.centerY.equalTo(typeImage)
            make.leading.equalTo(typeImage.snp.trailing).offset(5)
        }
        
        self.frame.size.width = typeLabel.frame.width + typeImage.frame.width + 5
    }
    
    private func onSelectedCase(enumCase: LemmySortType) {
        typeLabel.text = enumCase.uppercasedLabel
    }
}
