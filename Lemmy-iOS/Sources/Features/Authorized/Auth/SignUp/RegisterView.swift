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
        $0.text = "sign-up-register".localized
        $0.font = .boldSystemFont(ofSize: 23)
    }

    lazy var usernameTextField = UITextField().then {
        $0.placeholder = "sign-up-username".localized
        $0.textContentType = .username
        $0.autocorrectionType = .no
    }

    lazy var emailTextField = UITextField().then {
        $0.placeholder = "sign-up-email".localized
        $0.textContentType = .emailAddress
        $0.autocorrectionType = .no
    }

    lazy var emailDescription = UILabel().then {
        $0.textColor = .label
        $0.text = "sign-up-email-description".localized
        $0.numberOfLines = 0
        $0.textColor = .systemGray3
        $0.font = .systemFont(ofSize: 14)
    }

    lazy var passwordTextField = UITextField().then {
        $0.isSecureTextEntry = true
        $0.placeholder = "sign-up-password".localized
        $0.autocorrectionType = .no
    }

    lazy var passwordVerifyTextField = UITextField().then {
        $0.isSecureTextEntry = true
        $0.placeholder = "sign-up-password-verify".localized
        $0.autocorrectionType = .no
    }

    lazy var captchaImageView = UIImageView()

    lazy var captchaTextField = UITextField().then {
        $0.placeholder = "sign-up-code".localized
        $0.autocapitalizationType = .none
        $0.textContentType = .oneTimeCode
        $0.autocorrectionType = .no
    }

    // Apple rejects apps when user can choose to show nsfw content
//    lazy var showNsfwSwitch: LemmyLabelWithSwitch = {
//        let switcher = LemmyLabelWithSwitch()
//        switcher.checkText = "sign-up-show-nsfw".localized
//        return switcher
//    }()

    init() {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.systemBackground

        updateCaptcha()

        captchaImageView.addTap { [self] in
            updateCaptcha()
        }

        [
            signUpLabel,
            usernameTextField,
            emailTextField,
            emailDescription,
            passwordTextField,
            passwordVerifyTextField,
            captchaImageView,
            captchaTextField
//            showNsfwSwitch, // Apple rejects apps when user can choose to show nsfw content
        ].forEach { [self] (view) in
            self.addSubview(view)
        }
        
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateCaptcha() {
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

        // Apple rejects apps when user can choose to show nsfw content
//        showNsfwSwitch.snp.makeConstraints { (make) in
//            make.top.equalTo(captchaTextField.snp.bottom).offset(10)
//            make.leading.trailing.equalToSuperview().inset(20)
//        }
    }
}
