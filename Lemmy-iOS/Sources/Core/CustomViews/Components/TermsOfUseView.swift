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
        $0.textAlignment = .center
        return $0
    }(NoSelectTextView())
    
    private var acceptAttributedString: NSMutableAttributedString = {
        let plainAttributedString = NSMutableAttributedString(
            string: "By continuing you accept our ",
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                         NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        
        let attributedLinkStringTerms = NSMutableAttributedString(
            string: "Terms of use",
            attributes: [NSAttributedString.Key.link:
                            URL(string: "https://uuttff8.github.io/static/apps/Lemmer/terms")!,
                         NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        )
        
        let attributeAnd = NSMutableAttributedString(
            string: " and ",
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                         NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        let attributedLinkStringPrivacy = NSMutableAttributedString(
            string: "Privacy Policy",
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
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 60)
    }
}

extension TermsOfUseView: ProgrammaticallyViewProtocol {
    func setupView() {
        
    }
    
    func addSubviews() {
        self.addSubview(textView)
    }
    
    func makeConstraints() {
        textView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        self.snp.makeConstraints {
            $0.height.equalTo(textView.snp.height)
        }
    }
}
