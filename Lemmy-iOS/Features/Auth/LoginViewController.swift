//
//  ViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/11/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

enum LemmyAuthMethod {
    case signin, signup
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
        case .signin:
            let signIn = SignInView()
            self.signInView = signIn
            self.view = signIn
        case .signup:
            let signUp = SignUpView()
            self.signUpView = signUp
            self.view = signUp
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        signInView?.onSignIn = { (emailOrUsername, password) in
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
        
        signUpView?.onSignUp = { (username, email, password, passwordVerify) in
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

