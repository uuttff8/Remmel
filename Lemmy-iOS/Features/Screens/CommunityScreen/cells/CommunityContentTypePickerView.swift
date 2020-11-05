//
//  CommunityContentTypePickerCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 03.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CommunityContentTypePickerCell: UITableViewCell {
    let customView = LemmyImageTextTypePicker()
    
    init() {
        super.init(style: .default, reuseIdentifier: String(describing: Self.self))
        
        self.contentView.addSubview(customView)
        
        self.snp.makeConstraints {
            $0.edges.equalTo(customView)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LemmyImageTextTypePicker: UIView {
    
    var newCasePicked: ((LemmySortType) -> Void)?
    
    var currentPick = LemmySortType.active {
        didSet {
            if currentPick == oldValue { return }
            self.typeLabel.text = currentPick.uppercasedLabel
            newCasePicked?(currentPick)
        }
    }
    
    lazy var configuredAlert: UIAlertController = {
        let caseArray = LemmySortType.allCases
        
        let control = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        caseArray.forEach { (enumCase) in
            
            let action = UIAlertAction(
                title: enumCase.label,
                style: .default,
                handler: { _ in
                    self.currentPick = enumCase
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
        
        [typeImage, typeLabel].forEach {
            addSubview($0)
        }
        
        typeImage.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        typeLabel.snp.makeConstraints {
            $0.centerY.equalTo(typeImage)
            $0.leading.equalTo(typeImage.snp.trailing).offset(5)
        }
        
        self.snp.makeConstraints {
            $0.height.equalTo(35)
            $0.width.equalTo(100)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
