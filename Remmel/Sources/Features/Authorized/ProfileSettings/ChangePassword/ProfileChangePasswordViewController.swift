//
//  ProfileChangePasswordViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 01.05.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation
import UIKit
import RMFoundation

protocol ProfileChangePasswordViewControllerProtocol: AnyObject {
    func displayProfileChangePasswordForm(viewModel: ProfileChangePassword.Form.ViewModel)
    func displaySucessChangingPassword(viewModel: ProfileChangePassword.ChangePasswordResult)
}

final class ProfileChangePasswordViewController: UIViewController {
    
    enum TableFormType: String {
        case newPassword
        case verifyPassword
        case oldPassword
        
        init?(uniqueIdentifier: UniqueIdentifierType) {
            if let value = TableFormType(rawValue: uniqueIdentifier) {
                self = value
            } else {
                return nil
            }
        }
    }
    
    struct TableFormData {
        var newPassword: String?
        var verifyPassword: String?
        var oldPassword: String?
    }
    
    private lazy var profileChangePasswordView = self.view as? ProfileChangePasswordView
    
    private var tableFormData = TableFormData()
    
    private let viewModel: ProfileChangePasswordViewModelProtocol
    
    private lazy var updateBarButton = UIBarButtonItem(
        title: "profile-update".localized,
        style: .done,
        target: self,
        action: #selector(updateBarButtonTapped)
    )
    private lazy var _activityIndicator = UIActivityIndicatorView(style: .medium).then {
        $0.startAnimating()
    }
    private lazy var loadingBarButton = UIBarButtonItem(customView: _activityIndicator)
    
    init(viewModel: ProfileChangePasswordViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = ProfileChangePasswordView()
        view.delegate = self
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.doReceiveMessages()
        viewModel.doProfileChangePasswordForm(request: .init())
        self.navigationItem.rightBarButtonItem = updateBarButton
    }
    
    @objc private func updateBarButtonTapped() {
        guard let (oldP, verP, newP) = validatePasswords() else {
            UIAlertController.createOkAlert(message: "Your passwords are incorrect")
            return
        }
        
        self.setNewBarButton(loading: true)
        self.viewModel.doChangePassword(
            request: .init(
                oldPassword: oldP,
                newPassword: newP,
                verifyPassword: verP
            )
        )
    }
    
    private func validatePasswords() -> (String, String, String)? {
        guard let oldP = tableFormData.oldPassword, !oldP.isEmpty,
              let newP = tableFormData.newPassword, !newP.isEmpty,
              let verP = tableFormData.verifyPassword, !verP.isEmpty,
              newP == verP else {
            return nil
        }

        return (oldP, verP, newP)
    }
        
    private func dismissSelf() {
        self.dismiss(animated: true)
    }
    
    private func setNewBarButton(loading: Bool) {
        let button: UIBarButtonItem = loading ? loadingBarButton : updateBarButton
        self.navigationItem.rightBarButtonItem = button
    }

}

extension ProfileChangePasswordViewController: ProfileChangePasswordViewControllerProtocol {
    func displayProfileChangePasswordForm(viewModel: ProfileChangePassword.Form.ViewModel) {
        
        let oldPasswordCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableFormType.oldPassword.rawValue,
            type: .input(
                options: .init(
                    valueText: self.tableFormData.oldPassword,
                    placeholderText: "profile-old-password-hint".localized,
                    isEnabled: true,
                    capitalization: .none
                ))
        )
        
        let newPasswordCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableFormType.newPassword.rawValue,
            type: .input(
                options: .init(
                    valueText: self.tableFormData.newPassword,
                    placeholderText: "profile-new-password-hint".localized,
                    isEnabled: true,
                    capitalization: .none
                ))
        )
        
        let verifyPasswordCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableFormType.verifyPassword.rawValue,
            type: .input(
                options: .init(
                    valueText: self.tableFormData.verifyPassword,
                    placeholderText: "profile-verify-password-hint".localized,
                    isEnabled: true,
                    capitalization: .none
                ))
        )
        
        let sectionsViewModel: [SettingsTableSectionViewModel] = [
            .init(
                header: .init(title: "profile-password".localized),
                cells: [newPasswordCell, verifyPasswordCell, oldPasswordCell],
                footer: .init(description: "profile-password-footer".localized)
            )
        ]

        profileChangePasswordView?.configure(viewModel: SettingsTableViewModel(sections: sectionsViewModel))
    }
    
    func displaySucessChangingPassword(viewModel: ProfileChangePassword.ChangePasswordResult) {
        switch viewModel {
        case .success:
            UIAlertController.createOkAlert(message: "Your password is changed!")
        case .failed:
            break
        }
    }
}

extension ProfileChangePasswordViewController: ProfileChangePasswordViewDelegate {
    func settingsCell(
        elementView: UITextField,
        didReportTextChange text: String?,
        identifiedBy uniqueIdentifier: UniqueIdentifierType?
    ) {
        self.handleTextField(uniqueIdentifier: uniqueIdentifier, text: text)
    }
    
    func settingsCell(
        elementView: UITextView,
        didReportTextChange text: String,
        identifiedBy uniqueIdentifier: UniqueIdentifierType?
    ) {
        self.handleTextField(uniqueIdentifier: uniqueIdentifier, text: text)
    }
        
    private func handleTextField(uniqueIdentifier: UniqueIdentifierType?, text: String?) {
        guard let id = uniqueIdentifier, let field = TableFormType(uniqueIdentifier: id) else {
            return
        }
        
        switch field {
        case .newPassword:
            self.tableFormData.newPassword = text
        case .verifyPassword:
            self.tableFormData.verifyPassword = text
        case .oldPassword:
            self.tableFormData.oldPassword = text
        }
    }
}

extension ProfileChangePasswordViewController: StyledNavigationControllerPresentable {
    var navigationBarAppearanceOnFirstPresentation: StyledNavigationController.NavigationBarAppearanceState {
        .pageSheetAppearance()
    }
}
