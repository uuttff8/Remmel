//
//  AddInstanceView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 21.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Nuke
import RMDesignSystem

protocol AddInstanceViewDelegate: AnyObject {
    func addInstanceView(_ view: AddInstanceView, didTyped text: String?)
}

extension AddInstanceView {
    struct Appearance {
        let iconSize = CGSize(width: 50, height: 50)
    }
}

final class AddInstanceView: UIView {
    
    weak var delegate: AddInstanceViewDelegate?
    
    let appearance: Appearance
    
    private lazy var scrollableStackView = ScrollableStackView(orientation: .vertical).then {
        $0.spacing = 5
    }
    
    private lazy var textField: TextField = {
        $0.placeholder = "instances-new-instance".localized
        $0.textField.keyboardType = .URL
        $0.textField.autocapitalizationType = .none
        $0.textField.autocorrectionType = .no
        $0.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return $0
    }(TextField())
    
    private lazy var instanceImageView = UIImageView().then {
        $0.frame.size = appearance.iconSize
    }
    
    init(appearance: Appearance = Appearance()) {
        self.appearance = appearance
        super.init(frame: .zero)
        
        setupView()
        addSubviews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindImage(with url: URL?) {
        instanceImageView.loadImage(urlString: url, imageSize: appearance.iconSize)
    }
    
    func unbindImage() {
        instanceImageView.image = nil
    }
    
    // MARK: Actions
    @objc
    private func reload(_ textField: UITextField) {
        if let text = textField.text?.lowercased(), !text.isEmpty {
            delegate?.addInstanceView(self, didTyped: text)
        }
    }

    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(reload(_:)),
                                               object: textField)
        perform(#selector(reload(_:)), with: textField, afterDelay: 1.0)
    }
}

extension AddInstanceView: ProgrammaticallyViewProtocol {
    func setupView() {
        backgroundColor = .systemGroupedBackground
        scrollableStackView.contentInsets = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
    }
    
    func addSubviews() {
        addSubview(scrollableStackView)
        scrollableStackView.addArrangedView(textField)
        
        let view = UIView()
        view.addSubview(instanceImageView)
        instanceImageView.center = view.center
        scrollableStackView.addArrangedView(view)
    }
    
    func makeConstraints() {
        instanceImageView.snp.makeConstraints {
            $0.size.equalTo(50)
        }
        
        scrollableStackView.snp.makeConstraints {
            $0.top.bottom.equalTo(self.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        textField.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
    }
}
