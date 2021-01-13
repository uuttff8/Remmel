//
//  RegisterView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/13/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class RegisterView: UIView {
    struct ViewData {
        let username: String
        let email: String
        let password: String?
        let passwordVerify: String
        let captchaCode: String
    }

    var onSignUp: ((ViewData) -> Void)?

    let model = RegisterViewModel()

    lazy var signUpLabel = UILabel().then {
        $0.text = "Sign up"
        $0.font = .boldSystemFont(ofSize: 23)
    }

    lazy var usernameTextField = UITextField().then {
        $0.placeholder = "Username"
        $0.textContentType = .username
    }

    lazy var emailTextField = UITextField().then {
        $0.placeholder = "Email"
        $0.textContentType = .emailAddress
    }

    lazy var emailDescription = UILabel().then {
        $0.textColor = .label
        $0.text = "You will not be able to reset your password without an email."
        $0.numberOfLines = 0
        $0.textColor = .systemGray3
        $0.font = .systemFont(ofSize: 14)
    }

    lazy var passwordTextField = UITextField().then {
        $0.isSecureTextEntry = true
        $0.placeholder = "Password"
    }

    lazy var passwordVerifyTextField = UITextField().then {
        $0.isSecureTextEntry = true
        $0.placeholder = "Verify Password"
    }

    lazy var captchaImageView = UIImageView()

    lazy var captchaTextField = UITextField().then {
        $0.placeholder = "Captcha code"
        $0.autocapitalizationType = .none
        $0.textContentType = .oneTimeCode
    }

    lazy var showNsfwSwitch: LemmyLabelWithSwitch = {
        let switcher = LemmyLabelWithSwitch()
        switcher.checkText = "Show NSFW content"
        return switcher
    }()

    init() {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.systemBackground

        getCaptcha()

        captchaImageView.addTap { [self] in
            getCaptcha()
        }

        [
            signUpLabel,
            usernameTextField,
            emailTextField, emailDescription,
            passwordTextField, passwordVerifyTextField,
            captchaImageView, captchaTextField,
            showNsfwSwitch
        ].forEach { [self] (view) in
            self.addSubview(view)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getCaptcha() {
        model.getCaptcha { [self] (res) in
            switch res {
            case .success(let image):
                DispatchQueue.main.async {
                    captchaImageView.image = image
                }
            default: break
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        signUpLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        usernameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(signUpLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(35)
        }

        emailTextField.snp.makeConstraints { (make) in
            make.top.equalTo(usernameTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(35)
        }

        emailDescription.snp.makeConstraints { (make) in
            make.top.equalTo(emailTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(emailDescription.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(35)
        }

        passwordVerifyTextField.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(35)
        }

        captchaImageView.snp.makeConstraints { (make) in
            make.top.equalTo(passwordVerifyTextField.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(20)
            make.trailing.lessThanOrEqualToSuperview().inset(20)
            make.height.equalTo(100)
            make.width.equalTo(200)
        }

        captchaTextField.snp.makeConstraints { (make) in
            make.top.equalTo(captchaImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(35)
        }

        showNsfwSwitch.snp.makeConstraints { (make) in
            make.top.equalTo(captchaTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
