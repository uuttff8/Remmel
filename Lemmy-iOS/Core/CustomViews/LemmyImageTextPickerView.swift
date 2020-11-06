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
    
    let typeImageView = UIImageView()
    
    let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 5
    }
    
    init(cases: T.Type, firstPicked: T, image: UIImage) {
        self.currentPick = firstPicked
        self.caseArray = cases
        self.typeImageView.image = image
        super.init(frame: .zero)
        
        self.addSubview(stackView)
        
        stackView.addStackViewItems(
            .view(typeImageView),
            .view(typeLabel)
        )
        
        self.stackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
                
        self.snp.makeConstraints {
            $0.size.equalTo(stackView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
