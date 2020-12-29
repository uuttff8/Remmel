//
//  AuthenticationView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/13/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class AuthenticationView: UIView {
    var onSignIn: ((_ emailOrUsername: String, _ password: String) -> Void)?

    lazy var signInLabel = UILabel().then {
        $0.text = "Sign in"
        $0.font = .boldSystemFont(ofSize: 23)
    }

    lazy var emailOrUsernameTextField = UITextField().then {
        $0.placeholder = "Email or username"
        $0.autocapitalizationType = .none
        $0.textContentType = .username
    }

    lazy var passwordTextField = UITextField().then {
        $0.placeholder = "Password"
        $0.isSecureTextEntry = true
        $0.textContentType = .password
    }

    init() {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.systemBackground

        [signInLabel, emailOrUsernameTextField, passwordTextField].forEach { [self] (view) in
            self.addSubview(view)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        signInLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        emailOrUsernameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(signInLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(35)
        }

        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(emailOrUsernameTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(35)
        }
    }
}
