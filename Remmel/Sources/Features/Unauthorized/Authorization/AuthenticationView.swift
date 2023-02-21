//
//  AuthenticationView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/13/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMFoundation
import RMDesignSystem

class AuthenticationView: UIView {
    var onSignIn: ((_ emailOrUsername: String, _ password: String) -> Void)?

    lazy var signInLabel = UILabel().then {
        $0.text = "sign-in-signin".localized
        $0.font = .boldSystemFont(ofSize: 23)
    }

    lazy var emailOrUsernameTextField: TextField = {
        $0.placeholder = "sign-in-email-username".localized
        $0.textField.autocapitalizationType = .none
        $0.textField.textContentType = .username
        $0.textField.autocorrectionType = .no
        return $0
    }(TextField())

    lazy var passwordTextField: TextField = {
        $0.placeholder = "sign-in-password".localized
        $0.textField.isSecureTextEntry = true
        $0.textField.textContentType = .password
        $0.textField.autocorrectionType = .no
        return $0
    }(TextField())

    init() {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.systemGroupedBackground

        [signInLabel, emailOrUsernameTextField, passwordTextField].forEach { [self] view in
            self.addSubview(view)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        signInLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        emailOrUsernameTextField.snp.makeConstraints { make in
            make.top.equalTo(signInLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }

        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailOrUsernameTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
    }
}
