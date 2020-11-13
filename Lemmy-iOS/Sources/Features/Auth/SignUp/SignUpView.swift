//
//  SignUpView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/13/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class SignUpView: UIView {
    struct ViewDataSignUp {
        let username: String
        let email: String
        let password: String?
        let passwordVerify: String
        let captchaCode: String
    }

    var onSignUp: ((ViewDataSignUp) -> Void)?

    let model = SignUpModel()

    lazy var signUpLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Sign up"
        lbl.font = .boldSystemFont(ofSize: 23)
        return lbl
    }()

    lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        return textField
    }()

    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        return tf
    }()

    lazy var emailDescription: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.text = "You will not be able to reset your password without an email."
        lbl.numberOfLines = 0
        lbl.textColor = .systemGray3
        lbl.font = .systemFont(ofSize: 14)
        return lbl
    }()

    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.placeholder = "Password"
        return textField
    }()

    lazy var passwordVerifyTextField: UITextField = {
        let tf = UITextField()
        tf.isSecureTextEntry = true
        tf.placeholder = "Verify Password"
        return tf
    }()

    lazy var captchaImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()

    lazy var captchaTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Captcha code"
        tf.autocapitalizationType = .none
        return tf
    }()

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
