//
//  ViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/11/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

enum LemmyAuthMethod {
    case login, register
}

class LoginViewController: UIViewController {
    
    var signInView: SignInView?
    var signUpView: SignUpView?
    let shareData = LemmyShareData.shared
    
    let authMethod: LemmyAuthMethod
    
    init(authMethod: LemmyAuthMethod) {
        self.authMethod = authMethod
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        switch authMethod {
        case .login:
            let signIn = SignInView()
            self.signInView = signIn
            self.view = signIn
        case .register:
            let signUp = SignUpView()
            self.signUpView = signUp
            self.view = signUp
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        let barItemTitle: String
        
        switch authMethod {
        case .login:
            barItemTitle = "Login"
        case .register:
            barItemTitle = "Register"
        }
        
        let barItem = UIBarButtonItem(title: barItemTitle, style: .plain, target: self, action: #selector(onLoginOrRegisterSelector(sender:)))
        navigationItem.rightBarButtonItem = barItem
    }
    
    @objc func onLoginOrRegisterSelector(sender: UIBarButtonItem!) {
        switch authMethod {
        case .login:
            onSignIn()
        case .register:
            onSignUp()
        }
    }
    
    private func onSignUp() {
        guard let signUpView = signUpView else { return }
        
        guard (signUpView.passwordTextField.hasText)
                || (signUpView.usernameTextField.hasText)
                || (signUpView.passwordVerifyTextField.hasText)
        else {
            UIAlertController.createOkAlert(message: "Please fill correct email or username or password")
            return
        }
        
        guard (signUpView.passwordTextField.text == signUpView.passwordVerifyTextField.text)
        else {
            UIAlertController.createOkAlert(message: "Passwords don't match")
            return
        }
        
        guard (signUpView.captchaTextField.hasText)
        else {
            UIAlertController.createOkAlert(message: "Please fill captcha")
            return
        }
        
        guard let username = signUpView.usernameTextField.text,
              let email = signUpView.emailTextField.text,
              let password = signUpView.passwordTextField.text,
              let passwordVerify = signUpView.passwordVerifyTextField.text,
              let captchaCode = signUpView.captchaTextField.text else { return }
        

    }
    
    private func onSignIn() {
        guard let signInView = signInView else { return }
        
        if (!signInView.passwordTextField.hasText) || (!signInView.emailOrUsernameTextField.hasText) {
            UIAlertController.createOkAlert(message: "Please fill correct email or username or password")
        }
        
        guard let emailOrUsername = signInView.emailOrUsernameTextField.text,
              let password = signInView.passwordTextField.text
        else { return }
        
        
        
        let parameters = LemmyApiStructs.Authentication
            .LoginRequest(usernameOrEmail: emailOrUsername, password: password)
        
        ApiManager.shared.requestsManager.login(parameters: parameters)
        { (res: Result<LemmyApiStructs.Authentication.LoginResponse, Error>) in
            switch res {
            case let .failure(error):
                DispatchQueue.main.async {
                    UIAlertController.createOkAlert(message: error as! String)
                }
            case let .success(loginJwt):
                self.shareData.loginData.login(jwt: loginJwt.jwt)
                self.loadUserOnSuccessLogin(jwt: loginJwt.jwt) { (myUser) in
                    self.shareData.userdata = myUser
                    
                    
                    DispatchQueue.main.async {
                        self.loginSuccessed()
                    }
                }
            }
        }
        
    }
    
    private func loadUserOnSuccessLogin(jwt: String, completion: @escaping ((LemmyApiStructs.MyUser) -> Void)) {
        let params = LemmyApiStructs.Site.GetSiteRequest(auth: jwt)
        
        ApiManager.shared.requestsManager.getSite(parameters: params)
        { (res: Result<LemmyApiStructs.Site.GetSiteResponse, Error>) in
            switch res {
            case let .failure(error):
                print(error)
            case let .success(data):
                guard let myUser = data.myUser else { return }
                completion(myUser)
            }
        }
    }
    
    private func loginSuccessed() {
        NotificationCenter.default.post(name: .didLogin, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
}

