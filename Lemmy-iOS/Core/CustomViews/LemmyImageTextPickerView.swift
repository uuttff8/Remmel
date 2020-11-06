//
//  LemmyImageTextPickerView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol LemmyTypePickable {
    var label: String { get }
}

class LemmyImageTextTypePicker<T: CaseIterable & LemmyTypePickable & Equatable>: UIView {
    
    var newCasePicked: ((T) -> Void)?
    
    var image: UIImage?
    var text: String?
    
    let caseArray: T.Type
    
    var currentPick: T {
        didSet {
            if currentPick == oldValue { return }
            self.typeLabel.text = currentPick.label.uppercased()
            newCasePicked?(currentPick)
        }
    }
    
    lazy var configuredAlert: UIAlertController = {
        let control = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        caseArray.allCases.forEach { (enumCase) in
            
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
        $0.text = currentPick.label.uppercased()
        $0.textColor = .lightGray
    }
    
    let typeImage = UIImageView().then {
        let image = UIImage(systemName: "checkmark.seal.fill")!
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        $0.image = image
    }
    
    init(cases: T.Type, firstPicked: T) {
        self.currentPick = firstPicked
        self.caseArray = cases
        
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
            $0.height.equalTo(40)
            $0.width.equalTo(150)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
