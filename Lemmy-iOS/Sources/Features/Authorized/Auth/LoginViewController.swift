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
        
    var signInView: AuthenticationView?
    var signUpView: RegisterView?
    let shareData = LemmyShareData.shared
    
    let authMethod: LemmyAuthMethod
    
    private var cancellables = Set<AnyCancellable>()
    
    init(authMethod: LemmyAuthMethod) {
        self.authMethod = authMethod
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
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
            barItemTitle = "alert-login".localized
        case .register:
            barItemTitle = "alert-register".localized
        }
        
        let barItem = UIBarButtonItem(
            title: barItemTitle,
            style: .plain,
            target: self,
            action: #selector(onLoginOrRegisterSelector(sender:))
        )
        navigationItem.rightBarButtonItem = barItem
    }    
    
    @objc func onLoginOrRegisterSelector(sender: UIBarButtonItem!) {
        switch authMethod {
        case .auth:
            onSignIn()
        case .register:
            onSignUp()
        }
    }
        
    private func checkRegisterData() -> LMModels.Api.Person.Register? {
        guard let signUpView = signUpView else { return nil }
        
        guard (signUpView.passwordTextField.hasText)
                || (signUpView.usernameTextField.hasText)
                || (signUpView.passwordVerifyTextField.hasText)
        else {
            UIAlertController.createOkAlert(message: "login-error-email-user".localized)
            return nil
        }
        
        guard signUpView.passwordTextField.text == signUpView.passwordVerifyTextField.text
        else {
            UIAlertController.createOkAlert(message: "login-error-password-dont-match".localized)
            return nil
        }
        
        guard signUpView.captchaTextField.hasText
        else {
            UIAlertController.createOkAlert(message: "login-error-nocaptcha".localized)
            return nil
        }
        
        guard let username = signUpView.usernameTextField.text,
              let password = signUpView.passwordTextField.text,
              let passwordVerify = signUpView.passwordVerifyTextField.text,
              let captchaCode = signUpView.captchaTextField.text
        else { return nil }
        
        guard let uuid = signUpView.model.uuid else { return nil }
        
        // Apple rejects apps when user can choose to show nsfw content
        let showNsfw = true /* registerView.showNsfwSwitch.switcher.isOn */
        var email = signUpView.emailTextField.text
        if email == "" {
            email = nil
        }
        
        return LMModels.Api.Person.Register(
            username: username,
            email: email,
            password: password,
            passwordVerify: passwordVerify,
            showNsfw: showNsfw,
            captchaUuid: uuid,
            captchaAnswer: captchaCode,
            honeypot: nil,
            answer: nil
        )
    }
    
    private func onSignUp() {
        guard let params = checkRegisterData() else { return }
        
        ApiManager.requests.asyncRegister(parameters: params)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (completion) in
                Logger.logCombineCompletion(completion)
                
                if case let .failure(why) = completion {
                    UIAlertController.createOkAlert(message: why.description)
                    self.signUpView?.updateCaptcha()
                }
            }, receiveValue: { (response) in
                
                guard let jwt = response.jwt else {
                    return
                }
                
                self.shareData.loginData.login(jwt: jwt)
                self.loadUserOnSuccessResponse(jwt: jwt) { (myUser) in
                    LemmyShareData.shared.userdata = myUser
                    
                    DispatchQueue.main.async {
                        self.loginSuccessed()
                    }
                }
            }).store(in: &cancellables)
    }
    
    private func onSignIn() {
        guard let signInView = signInView else { return }
        
        if (!signInView.passwordTextField.hasText) || (!signInView.emailOrUsernameTextField.hasText) {
            UIAlertController.createOkAlert(message: "login-error-email-user".localized)
        }
        
        guard let emailOrUsername = signInView.emailOrUsernameTextField.text,
              let password = signInView.passwordTextField.text
        else { return }
        
        let parameters = LMModels.Api.Person.Login(
            usernameOrEmail: emailOrUsername,
            password: password
        )
        
        ApiManager.requests.asyncLogin(parameters: parameters)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (completion) in
                Logger.logCombineCompletion(completion)
                
                if case let .failure(why) = completion {
                    UIAlertController.createOkAlert(message: why.description)
                }
            }, receiveValue: { (response) in
                
                guard let jwt = response.jwt else {
                    return
                }
                
                self.shareData.loginData.login(jwt: jwt)
                self.loadUserOnSuccessResponse(jwt: jwt) { (myUser) in
                    LemmyShareData.shared.userdata = myUser
                    
                    DispatchQueue.main.async {
                        self.loginSuccessed()
                    }
                }
            }).store(in: &cancellables)
    }
        
    private func loadUserOnSuccessResponse(
        jwt: String,
        completion: @escaping ((LMModels.Api.Site.MyUserInfo) -> Void)
    ) {
        
        let params = LMModels.Api.Site.GetSite(auth: jwt)
        
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

extension LoginViewController: StyledNavigationControllerPresentable {
    var navigationBarAppearanceOnFirstPresentation: StyledNavigationController.NavigationBarAppearanceState {
        .pageSheetAppearance()
    }
}
