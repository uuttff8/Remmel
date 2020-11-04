//
//  CommunityContentTypePickerCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 03.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CommunityContentTypePickerView: UIView {
    let contentTypePicker = LemmyImageTextTypePicker()
    
    init() {
        super.init(frame: .zero)
        
        self.addSubview(contentTypePicker)
        
        contentTypePicker.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
                
        self.snp.makeConstraints {
            $0.edges.equalTo(contentTypePicker)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LemmyImageTextTypePicker: UIView {
    
    let currentPick = LemmySortType.active
    
    lazy var configuredAlert: UIAlertController = {
        let caseArray = LemmySortType.allCases
        
        let control = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        caseArray.forEach { (enumCase) in
            
            let action = UIAlertAction(
                title: enumCase.label,
                style: .default,
                handler: { _ in
                    if self.currentPick != enumCase {
                        self.typeLabel.text = enumCase.uppercasedLabel
                    }
                })
            
            control.addAction(action)
        }
        control.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        
        return control
    }()
    
    lazy var typeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.text = currentPick.uppercasedLabel
        $0.textColor = .lightGray
    }
    
    let typeImage = UIImageView().then {
        let image = UIImage(systemName: "checkmark.seal.fill")!
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        $0.image = image
    }
    
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
    }
}
