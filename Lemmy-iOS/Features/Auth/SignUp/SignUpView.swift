//
//  SignUpView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/13/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class SignUpView: UIView {
    var onSignUp: ((_ username: String, _ email: String, _ password: String?, _ passwordVerify: String, _ captchaCode: String) -> Void)?
    
    let model = SignUpModel()
    
    private lazy var signUpLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Sign up"
        lbl.font = .boldSystemFont(ofSize: 23)
        return lbl
    }()
    
    private lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        return textField
    }()
    
    private lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        return tf
    }()
    
    private lazy var emailDescription: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.text = "You will not be able to reset your password without an email."
        lbl.numberOfLines = 0
        lbl.textColor = .systemGray3
        lbl.font = .systemFont(ofSize: 14)
        return lbl
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        return textField
    }()
    
    private lazy var passwordVerifyTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Verify Password"
        return tf
    }()
    
    private lazy var registerButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Register", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = 17
        btn.tintColor = .white
        return btn
    }()
    
    private lazy var captchaImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    private lazy var captchaTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Captcha code"
        return tf
    }()
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.systemBackground
        
        model.getCaptcha { [self] (res) in
            switch res {
            case .success(let image):
                DispatchQueue.main.async {
                    captchaImageView.image = image
                }
            default: break
            }
        }
        
        [
            signUpLabel,
            usernameTextField,
            emailTextField, emailDescription,
            passwordTextField, passwordVerifyTextField,
            captchaImageView, captchaTextField,
            registerButton
        ].forEach { [self] (view) in
            self.addSubview(view)
        }
        
        registerButton.addTarget(self, action: #selector(registerButtonTapped(sender:)), for: .touchUpInside)
        
    }
    
    @objc func registerButtonTapped(sender: UIButton!) {
        guard (!passwordTextField.hasText) || (!usernameTextField.hasText) || (!passwordVerifyTextField.hasText)
        else {
            UIAlertController.createOkAlert(message: "Please fill correct email or username or password")
            return
        }
        
        guard (passwordTextField.text != passwordVerifyTextField.text)
        else {
            UIAlertController.createOkAlert(message: "Passwords don't match")
            return
        }
        
        guard (!captchaTextField.hasText)
        else {
            UIAlertController.createOkAlert(message: "Please fill captcha")
            return
        }
        
        guard let username = usernameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              let passwordVerify = passwordVerifyTextField.text,
              let captchaCode = captchaTextField.text else { return }
        
        // TODO(uuttff8): Make Captcha support
        onSignUp?(username,
                  email,
                  password,
                  passwordVerify,
                  captchaCode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        signUpLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(40)
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
        
        registerButton.snp.makeConstraints { (make) in
            make.top.equalTo(captchaTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
            make.width.equalTo(100)
        }
    }
}
