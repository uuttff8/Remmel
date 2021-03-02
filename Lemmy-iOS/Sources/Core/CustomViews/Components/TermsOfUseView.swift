//
//  TermsOfUseView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 11.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

private class NoSelectTextView: UITextView {
    override var canBecomeFirstResponder: Bool {
        false
    }
}

final class TermsOfUseView: UIView {
    
    private lazy var textView: NoSelectTextView = {
        $0.isUserInteractionEnabled = true
        $0.isEditable = false
        $0.attributedText = acceptAttributedString
        $0.textColor = .label
        $0.textAlignment = .center
        $0.backgroundColor = .clear
        return $0
    }(NoSelectTextView())
    
    private var acceptAttributedString: NSMutableAttributedString = {
        let plainAttributedString = NSMutableAttributedString(
            string: "instances-terms-1".localized,
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                         NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        
        let attributedLinkStringTerms = NSMutableAttributedString(
            string: "instances-terms-2".localized,
            attributes: [NSAttributedString.Key.link:
                            URL(string: "https://uuttff8.github.io/static/apps/Lemmer/terms")!,
                         NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        )
        
        let attributeAnd = NSMutableAttributedString(
            string: "instances-terms-3".localized,
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                         NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        let attributedLinkStringPrivacy = NSMutableAttributedString(
            string: "instances-terms-4".localized,
            attributes: [NSAttributedString.Key.link:
                            URL(string: "https://uuttff8.github.io/static/apps/Lemmer/privacy")!,
                         NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        )
        
        let fullAttributedString = NSMutableAttributedString()
        fullAttributedString.append(plainAttributedString)
        fullAttributedString.append(attributedLinkStringTerms)
        fullAttributedString.append(attributeAnd)
        fullAttributedString.append(attributedLinkStringPrivacy)
        return fullAttributedString
    }()

    init() {
        super.init(frame: .zero)
        
        setupView()
        addSubviews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TermsOfUseView: ProgrammaticallyViewProtocol {
    func setupView() {
        self.backgroundColor = .clear
    }
    
    func addSubviews() {
        self.addSubview(textView)
    }
    
    func makeConstraints() {
        textView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.height.equalTo(80)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        self.snp.makeConstraints {
            $0.height.equalTo(textView.snp.height)
        }
    }
}
