//
//  AddInstanceView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 21.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol AddInstanceViewDelegate: AnyObject {
    func addInstanceView(_ view: AddInstanceView, didTyped text: String)
}

final class AddInstanceView: UIView {
    
    weak var delegate: AddInstanceViewDelegate?
    
    private lazy var scrollableStackView = ScrollableStackView(orientation: .vertical)
    
    private lazy var textField = UITextField().then {
        $0.placeholder = "Enter instance link here"
        $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    init() {
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    @objc
    private func reload(_ textField: UITextField) {
        if let text = textField.text, text != "" {
            self.delegate?.addInstanceView(self, didTyped: text)
        } else {
            
        }
    }

    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(reload(_:)),
                                               object: textField)
        self.perform(#selector(reload(_:)), with: textField, afterDelay: 0.5)
    }
}
