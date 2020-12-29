//
//  ViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/11/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    
    weak var coordinator: LoginCoordinator?
    
    var signInView: AuthenticationView?
    var signUpView: RegisterView?
    let shareData = LemmyShareData.shared
    
    let authMethod: LemmyAuthMethod
    
    private var cancellables = Set<AnyCancellable>()
    
    init(authMethod: LemmyAuthMethod) {
        self.authMethod = authMethod
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        switch authMethod {
        case .auth:
            let signIn = AuthenticationView()
            self.signInView = signIn
            self.view = signIn
        case .register:
            let signUp = RegisterView()
            self.signUpView = signUp
            self.view = signUp
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.hideKeyboardWhenTappedAround()
        
        let barItemTitle: String
        
        switch authMethod {
        case .auth:
            barItemTitle = "Login"
        case .register:
            barItemTitle = "Register"
        }
        
        let barItem = UIBarButtonItem(
            title: barItemTitle,
            style: .plain,
            target: self,
            action: #selector(onLoginOrRegisterSelector(sender:))
        )
        navigationItem.rightBarButtonItem = barItem
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.coordinator?.removeDependency(coordinator)
    }
    
    @objc func onLoginOrRegisterSelector(sender: UIBarButtonItem!) {
        switch authMethod {
        case .auth:
            onSignIn()
        case .register:
            onSignUp()
        }
    }
    
    private func onSignUp() {
        guard let params = checkRegisterData() else { return }
        
        ApiManager.requests.asyncRegister(parameters: params)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (completion) in
                if case let .failure(why) = completion {
                    UIAlertController.createOkAlert(message: why.description)
                }
                
                Logger.logCombineCompletion(completion)
            }, receiveValue: { (response) in
                // TODO: add registration flow next
                print(response)
            }).store(in: &cancellables)
    }
    
    private func checkRegisterData() -> LemmyModel.Authentication.RegisterRequest? {
        guard let signUpView = signUpView else { return nil }
        
        guard (signUpView.passwordTextField.hasText)
                || (signUpView.usernameTextField.hasText)
                || (signUpView.passwordVerifyTextField.hasText)
        else {
            UIAlertController.createOkAlert(message: "Please fill correct email or username or password")
            return nil
        }
        
        guard signUpView.passwordTextField.text == signUpView.passwordVerifyTextField.text
        else {
            UIAlertController.createOkAlert(message: "Passwords don't match")
            return nil
        }
        
        guard signUpView.captchaTextField.hasText
        else {
            UIAlertController.createOkAlert(message: "Please fill captcha")
            return nil
        }
        
        guard let username = signUpView.usernameTextField.text,
              let password = signUpView.passwordTextField.text,
              let passwordVerify = signUpView.passwordVerifyTextField.text,
              let captchaCode = signUpView.captchaTextField.text
        else { return nil }
        
        guard let uuid = signUpView.model.uuid else { return nil }
        
        let showNsfw = signUpView.showNsfwSwitch.switcher.isOn
        var email = signUpView.emailTextField.text
        if email == "" {
            email = nil
        }
        
        return LemmyModel.Authentication.RegisterRequest(username: username,
                                                         email: email,
                                                         password: password,
                                                         passwordVerify: passwordVerify,
                                                         admin: false,
                                                         showNsfw: showNsfw,
                                                         captchaUuid: uuid,
                                                         captchaAnswer: captchaCode)
        
    }
    
    private func onSignIn() {
        guard let signInView = signInView else { return }
        
        if (!signInView.passwordTextField.hasText) || (!signInView.emailOrUsernameTextField.hasText) {
            UIAlertController.createOkAlert(message: "Please fill correct email or username or password")
        }
        
        guard let emailOrUsername = signInView.emailOrUsernameTextField.text,
              let password = signInView.passwordTextField.text
        else { return }
        
        let parameters = LemmyModel.Authentication
            .LoginRequest(usernameOrEmail: emailOrUsername, password: password)
        
        ApiManager.requests.asyncLogin(parameters: parameters)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (completion) in
                if case let .failure(why) = completion {
                    UIAlertController.createOkAlert(message: why.description)
                }
                
                Logger.logCombineCompletion(completion)
            }, receiveValue: { (response) in
                self.shareData.loginData.login(jwt: response.jwt)
                self.loadUserOnSuccessLogin(jwt: response.jwt) { (myUser) in
                    LemmyShareData.shared.userdata = myUser
                    
                    DispatchQueue.main.async {
                        self.loginSuccessed()
                    }
                }
            }).store(in: &cancellables)
        
    }
    
    private func loadUserOnSuccessLogin(jwt: String, completion: @escaping ((LemmyModel.MyUser) -> Void)) {
        let params = LemmyModel.Site.GetSiteRequest(auth: jwt)
        
        ApiManager.requests.asyncGetSite(parameters: params)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (completion) in
                Logger.logCombineCompletion(completion)
            }, receiveValue: { (response) in
                guard let myUser = response.myUser else { return }
                completion(myUser)
            }).store(in: &cancellables)
    }
    
    private func loginSuccessed() {
        NotificationCenter.default.post(name: .didLogin, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
}
