//
//  AddAccountsViewController.swift
//  Lemmy-iOS
//
//  Created by Komolbek Ibragimov on 25/12/2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import CoreData

protocol AddAccountViewControllerProtocol: AnyObject {
    func displaySuccessAuth(viewModel: AddAccountDataFlow.Authentication.ViewModel)
    func displayErrorAuth(viewModel: AddAccountDataFlow.AuthError.ViewModel)
}

final class AddAccountViewController: UIViewController {
    
    var completionHandler: (() -> Void)?

    weak var coordinator: AccountsCoordinator?
    let viewModel: AddAccountViewModel
    
    private lazy var addAccountView = self.view as! AddAccountView
    
    private lazy var addBarButton = UIBarButtonItem(
        title: "accounts-add".localized,
        style: .done,
        target: self,
        action: #selector(addBarButtonTapped)
    )
    
    private let authMethod: LemmyAuthMethod
    
    init(viewModel: AddAccountViewModel, authMethod: LemmyAuthMethod) {
        self.authMethod = authMethod
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = AddAccountView(authMethod: authMethod)
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()
    }
    
    private func setupNavigationItem() {
        switch authMethod {
        case .auth:
            title = "sign-in-signin".localized
        case .register:
            title = "sign-up-signup".localized
        }
        self.navigationItem.rightBarButtonItem = addBarButton
    }
    
    private func onAuth() {
        let authView = addAccountView.authView
        
        if (!authView.passwordTextField.hasText) || (!authView.emailOrUsernameTextField.hasText) {
            UIAlertController.createOkAlert(message: "login-error-email-user".localized)
        }
        
        guard let login = authView.emailOrUsernameTextField.text,
              let password = authView.passwordTextField.text
        else { return }
        
        self.viewModel.doRemoteAuthentication(request: .init(emailOrUsername: login, password: password))
    }
    
    private func onRegister() {
        let registerView = addAccountView.registerView
        
        guard (registerView.passwordTextField.hasText)
                || (registerView.usernameTextField.hasText)
                || (registerView.passwordVerifyTextField.hasText)
        else {
            UIAlertController.createOkAlert(message: "login-error-email-user".localized)
            return
        }
        
        guard registerView.passwordTextField.text == registerView.passwordVerifyTextField.text
        else {
            UIAlertController.createOkAlert(message: "Passwords don't match")
            return
        }
        
        guard registerView.captchaTextField.hasText
        else {
            UIAlertController.createOkAlert(message: "Please fill captcha")
            return
        }
        
        guard let username = registerView.usernameTextField.text,
              let password = registerView.passwordTextField.text,
              let passwordVerify = registerView.passwordVerifyTextField.text,
              let captchaCode = registerView.captchaTextField.text
        else { return }
        
        guard let captchaUuid = registerView.model.uuid else { return }
        
        let showNsfw = registerView.showNsfwSwitch.switcher.isOn
        var email = registerView.emailTextField.text
        if email == "" {
            email = nil
        }
        
        viewModel.doRemoteRegister(
            request: .init(
                username: username,
                email: email,
                password: password,
                passwordVerify: passwordVerify,
                showNsfw: showNsfw,
                captchaUuid: captchaUuid,
                captchaAnswer: captchaCode
            )
        )
    }
    
    // MARK: - Actions
    @objc private func addBarButtonTapped(_ sender: UIBarButtonItem) {
        self.addBarButton.isEnabled = false
        switch authMethod {
        case .auth:
            onAuth()
        case .register:
            onRegister()
        }
    }
}

extension AddAccountViewController: AddAccountViewControllerProtocol {
    func displaySuccessAuth(viewModel: AddAccountDataFlow.Authentication.ViewModel) {
        self.coordinator?.dismissSelf(viewController: self)
        completionHandler?()
    }
    
    func displayErrorAuth(viewModel: AddAccountDataFlow.AuthError.ViewModel) {
        self.addBarButton.isEnabled = true
        UIAlertController.createOkAlert(message: viewModel.error)
    }
}
