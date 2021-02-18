//
//  SettingsInputWithImageCellView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 25.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import SnapKit

extension SettingsInputWithImageCellView {
    struct Appearance {
        let iconSize = CGSize(width: 30, height: 30)
        
        let trailingOffset: CGFloat = 8

        let containerMinHeight: CGFloat = 44
    }
}

final class SettingsInputWithImageCellView: UIView {
    
    enum UrlState: Equatable {
        case notAdded
        case loading
        case addWithImage(text: String)
        case urlAdded
        case error
    }
    
    let appearance: Appearance
    
    private(set) lazy var textField = TableInputTextField()
    
    private lazy var imageIconView = ImageControl()

    private lazy var containerView = UIView()
    
    var urlState = UrlState.notAdded
    
    var onIconImageTap: (() -> Void)?
    var onEnteredText: ((String?) -> Void)?

    var textFieldIsEnabled: Bool = true {
        didSet {
            self.textField.isEnabled = textFieldIsEnabled
        }
    }
    
    var title: String? {
        didSet {
            self.textField.text = self.title
        }
    }

    var titleTextColor: UIColor = .label {
        didSet {
            self.textField.textColor = self.titleTextColor
        }
    }

    var titleTextAlignment: NSTextAlignment = .natural {
        didSet {
            self.textField.textAlignment = self.titleTextAlignment
        }
    }
    
    var placeholderText: String? {
        didSet {
            self.textField.placeholder = placeholderText
        }
    }
    
    var imageIcon: UIImage? {
        didSet {
            self.imageIconView.innerImageView.image = imageIcon
        }
    }

    override init(frame: CGRect) {
        self.appearance = .init()
        super.init(frame: frame)

        self.setupView()
        self.addSubviews()
        self.makeConstraints()
        
        self.imageIconView.addTarget(self, action: #selector(imageTapped), for: .touchUpInside)
        self.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func imageTapped() {
        self.onIconImageTap?()
    }
    
    @objc func textFieldDidChange(_ textField: TableInputTextField) {
        self.onEnteredText?(textField.text)
    }
    
    func showLoading() {
        self.containerView.showActivityIndicatorView()
    }
    
    func hideLoading() {
        self.containerView.hideActivityIndicatorView()
    }
}

extension SettingsInputWithImageCellView: ProgrammaticallyViewProtocol {
    func setupView() { }
    
    func addSubviews() {
        self.addSubview(self.containerView)
        containerView.addSubview(textField)
        containerView.addSubview(imageIconView)
    }

    func makeConstraints() {
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.greaterThanOrEqualTo(self.appearance.containerMinHeight)
        }
        
        self.textField.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        self.textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        self.textField.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        self.textField.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        self.textField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.top.bottom.equalToSuperview()
            $0.trailing.equalTo(imageIconView.snp.leading)
        }
        
        self.imageIconView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        self.imageIconView.setContentHuggingPriority(.defaultLow, for: .vertical)
        self.textField.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        self.textField.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        self.imageIconView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(self.appearance.iconSize)
            $0.trailing.equalToSuperview().inset(self.appearance.trailingOffset)
        }
    }
}

