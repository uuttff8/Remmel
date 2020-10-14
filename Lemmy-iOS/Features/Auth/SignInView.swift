//
//  LoginScreenUI.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/13/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class SignInView: UIView {
    var onSignIn: ((_ emailOrUsername: String, _ password: String) -> Void)?
    
    private lazy var signInLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Sign in"
        lbl.font = .boldSystemFont(ofSize: 23)
        return lbl
    }()
    
    private lazy var emailOrUsernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email or username"
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private lazy var loginButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Login", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = 17
        btn.tintColor = .white
        return btn
    }()
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.systemBackground
        
        [signInLabel, emailOrUsernameTextField, passwordTextField, loginButton].forEach { [self] (view) in
            self.addSubview(view)
        }
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped(sender:)), for: .touchUpInside)
    }
    
    @objc func loginButtonTapped(sender: UIButton!) {
        if (!passwordTextField.hasText) || (!emailOrUsernameTextField.hasText) {
            UIAlertController.createOkAlert(message: "Please fill correct email or username or password")
        }
        
        guard let emailOrUsername = emailOrUsernameTextField.text,
              let password = passwordTextField.text
        else { return }
        
        onSignIn?(emailOrUsername, password)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        signInLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(40)
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
        
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
            make.width.equalTo(100)
        }
    }
}

