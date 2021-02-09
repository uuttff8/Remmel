//
//  ProfileSettingsViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 03.02.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol ProfileSettingsViewControllerProtocol: AnyObject {
    func displayProfileSettingsForm(viewModel: ProfileSettings.ProfileSettingsForm.ViewModel)
    func displayLoadingIndicator(viewModel: ProfileSettings.LoadingIndicator.ViewModel)
    func displayError(viewModel: ProfileSettings.SomeError.ViewModel)
    func displaySuccessUpdatingSetting()
}

final class ProfileSettingsViewController: UIViewController, CatalystDismissProtocol {
    
    enum TableFormType: String {
        case displayName
        case bio
        case email
        case matrix
        case newPassword
        case verifyPassword
        case oldPassword
        case showNsfwContent
        case sendNotificationsToEmail
        
        init?(uniqueIdentifier: UniqueIdentifierType) {
            if let value = TableFormType(rawValue: uniqueIdentifier) {
                self = value
            } else {
                return nil
            }
        }
    }
    
    struct TableFormData {
        var displayName: String?
        var bio: String?
        var email: String?
        var matrix: String?
        var newPassword: String?
        var verifyPassword: String?
        var oldPassword: String?
        var showNsfwContent: Bool = true
        var sendNotificationsToEmail: Bool = true
    }
    
    private let viewModel: ProfileSettingsViewModelProtocol
    
    private lazy var profileSettingsView = self.view as! ProfileSettingsView
    
    private var tableFormData = TableFormData()
    
    private lazy var _activityIndicator = UIActivityIndicatorView(style: .medium).then {
        $0.startAnimating()
    }
    private lazy var loadingBarButton = UIBarButtonItem(customView: _activityIndicator)
    
    private lazy var updateBarButton = UIBarButtonItem(
        title: "profile-update".localized,
        style: .done,
        target: self,
        action: #selector(updateBarButtonTapped)
    )
    
    init(viewModel: ProfileSettingsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func loadView() {
        let view = ProfileSettingsView()
        view.delegate = self
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // https://stackoverflow.com/questions/32696615/warning-attempt-to-present-on-which-is-already-presenting-null
        self.definesPresentationContext = true
        
        title = "profile-settings-title".localized
        self.navigationItem.rightBarButtonItem = updateBarButton
        self.viewModel.doProfileSettingsForm(request: .init())
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        self.dismissWithExitButton(presses: presses)
    }
    
    @objc private func updateBarButtonTapped() {
        self.nullifyEmptyPasswords()
        self.setNewBarButton(loading: true)
        self.viewModel.doRemoteProfileSettingsUpdate(request: .init(data: tableFormData))
    }
    
    private func nullifyEmptyPasswords() {
        if tableFormData.newPassword == "" { tableFormData.newPassword = nil }
        if tableFormData.oldPassword == "" { tableFormData.oldPassword = nil }
        if tableFormData.verifyPassword == "" { tableFormData.verifyPassword = nil }
    }
    
    private func dismissSelf() {
        self.dismiss(animated: true)
    }
    
    private func setNewBarButton(loading: Bool) {
        let button: UIBarButtonItem = loading ? loadingBarButton : updateBarButton
        self.navigationItem.rightBarButtonItem = button
    }
}

extension ProfileSettingsViewController: ProfileSettingsViewControllerProtocol {
    // swiftlint:disable function_body_length
    func displayProfileSettingsForm(viewModel: ProfileSettings.ProfileSettingsForm.ViewModel) {
        self.tableFormData.bio = viewModel.bio
        self.tableFormData.displayName = viewModel.displayName
        self.tableFormData.email = viewModel.email
        self.tableFormData.matrix = viewModel.matrix
        self.tableFormData.showNsfwContent = viewModel.nsfwContent
        self.tableFormData.sendNotificationsToEmail = viewModel.notifToEmail
        
        self.profileSettingsView.configure(viewModel: getNewTableData(viewModel: viewModel))
    }
    
    func displayLoadingIndicator(viewModel: ProfileSettings.LoadingIndicator.ViewModel) {
        viewModel.isLoading
            ? self.profileSettingsView.showLoadingIndicator()
            : self.profileSettingsView.hideLoadingIndicator()
    }
    
    func displayError(viewModel: ProfileSettings.SomeError.ViewModel) {
        self.setNewBarButton(loading: false)
        self.profileSettingsView.hideLoadingIndicator()
        UIAlertController.createOkAlert(
            message: viewModel.error,
            completion: {
                if viewModel.exitImmediately {
                    self.dismissSelf()
                }
            }
        )
    }
    
    func displaySuccessUpdatingSetting() {
        self.setNewBarButton(loading: false)
        self.dismissSelf()
    }
    
    private func updateTableViewModel() {
        let viewModel = getNewTableData(viewModel: .init(displayName: tableFormData.displayName,
                                                         bio: tableFormData.bio,
                                                         email: tableFormData.email,
                                                         matrix: tableFormData.matrix,
                                                         nsfwContent: tableFormData.showNsfwContent,
                                                         notifToEmail: tableFormData.sendNotificationsToEmail))
        
        self.profileSettingsView.updateData(viewModel: viewModel)
    }
    
    private func getNewTableData(viewModel: ProfileSettings.ProfileSettingsForm.ViewModel) -> SettingsTableViewModel {
        let displayNameCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableFormType.displayName.rawValue,
            type: .input(
                options: .init(
                    valueText: viewModel.displayName,
                    placeholderText: "profile-display-name-hint".localized,
                    isEnabled: true,
                    capitalization: .none
                ))
        )
        
        let bioCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableFormType.bio.rawValue,
            type: .largeInput(
                options: .init(
                    valueText: viewModel.bio,
                    placeholderText: "profile-bio-hint".localized
                ))
        )
        
        let emailCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableFormType.email.rawValue,
            type: .input(
                options: .init(
                    valueText: viewModel.email,
                    placeholderText: "profile-email-hint".localized,
                    isEnabled: true,
                    capitalization: .none
                ))
        )
        
        let matrixCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableFormType.matrix.rawValue,
            type: .input(
                options: .init(
                    valueText: viewModel.matrix,
                    placeholderText: "profile-matrix-hint".localized
                    ,
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
        
        let nsfwContentCheck = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableFormType.showNsfwContent.rawValue,
            type: .rightDetail(
                options: .init(
                    title: .init(text: "profile-show-nsfw".localized),
                    detailType: .switch(.init(isOn: viewModel.nsfwContent))
                ))
        )
        
        let sendNotifToEmailCheck = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableFormType.sendNotificationsToEmail.rawValue,
            type: .rightDetail(
                options: .init(
                    title: .init(text: "profile-send-notification-to-email".localized),
                    detailType: .switch(.init(isOn: viewModel.notifToEmail))
                ))
        )
        
        let sectionsViewModel: [SettingsTableSectionViewModel] = [
            .init(
                header: .init(title: "profile-display-name".localized),
                cells: [displayNameCell],
                footer: nil
            ),
            .init(
                header: .init(title: "profile-bio".localized),
                cells: [bioCell],
                footer: .init(description: "profile-bio-footer".localized)
            ),
            .init(
                header: .init(title: "profile-email-and-matrix".localized),
                cells: [emailCell, matrixCell],
                footer: nil
            ),
            .init(
                header: .init(title: "profile-password".localized),
                cells: [newPasswordCell, verifyPasswordCell, oldPasswordCell],
                footer: .init(description: "profile-password-footer".localized)
            ),
            .init(
                header: nil,
                cells: [nsfwContentCheck, sendNotifToEmailCheck],
                footer: nil
            )
        ]
        
        return SettingsTableViewModel(sections: sectionsViewModel)
    }
}

extension ProfileSettingsViewController: ProfileSettingsViewDelegate {
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
    
    func settingsCell(_ cell: SettingsRightDetailSwitchTableViewCell, switchValueChanged isOn: Bool) {
        guard let id = cell.uniqueIdentifier, let field = TableFormType(uniqueIdentifier: id) else {
            return
        }
        
        switch field {
        case .showNsfwContent:
            self.tableFormData.showNsfwContent = isOn
        case .sendNotificationsToEmail:
            self.tableFormData.sendNotificationsToEmail = isOn
        default: break
        }
        
        // safe changes
        updateTableViewModel()
    }
    
    private func handleTextField(uniqueIdentifier: UniqueIdentifierType?, text: String?) {
        guard let id = uniqueIdentifier, let field = TableFormType(uniqueIdentifier: id) else {
            return
        }
        
        switch field {
        case .displayName:
            self.tableFormData.displayName = text
        case .bio:
            self.tableFormData.bio = text
        case .email:
            self.tableFormData.email = text
        case .matrix:
            self.tableFormData.matrix = text
        case .newPassword:
            self.tableFormData.newPassword = text
        case .verifyPassword:
            self.tableFormData.verifyPassword = text
        case .oldPassword:
            self.tableFormData.oldPassword = text

        default: break
        }
        
        // safe changes
        self.updateTableViewModel()
    }
}

extension ProfileSettingsViewController: StyledNavigationControllerPresentable {
    var navigationBarAppearanceOnFirstPresentation: StyledNavigationController.NavigationBarAppearanceState {
        .pageSheetAppearance()
    }
}
