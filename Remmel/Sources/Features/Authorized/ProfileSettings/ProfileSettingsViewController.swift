//
//  ProfileSettingsViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 03.02.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMFoundation

protocol ProfileSettingsViewControllerProtocol: AnyObject {
    func displayProfileSettingsForm(viewModel: ProfileSettings.ProfileSettingsForm.ViewModel)
    func displayLoadingIndicator(viewModel: ProfileSettings.LoadingIndicator.ViewModel)
    func displayError(viewModel: ProfileSettings.SomeError.ViewModel)
    func displaySuccessUpdatingSetting()
}

final class ProfileSettingsViewController: UIViewController, CatalystDismissable {
    
    enum TableFormType: String {
        case displayName
        case bio
        case email
        case matrix
        case changePassword
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
        var showNsfwContent: Bool = true
        var sendNotificationsToEmail: Bool = true
    }
    
    weak var coordinator: ProfileScreenCoordinator?
    private let viewModel: ProfileSettingsViewModelProtocol
    private lazy var profileSettingsView = self.view as? ProfileSettingsView
    
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
    
    @available(macCatalyst 11.3, *)
    private lazy var closeBarButton = UIBarButtonItem(
        barButtonSystemItem: .close,
        target: self,
        action: #selector(dismissSelf)
    )
    
    init(viewModel: ProfileSettingsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("haah")
    }
    
    override func loadView() {
        let view = ProfileSettingsView()
        view.delegate = self
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // https://stackoverflow.com/questions/32696615/warning-attempt-to-present-on-which-is-already-presenting-null
        definesPresentationContext = true
        
        title = "profile-settings-title".localized
        navigationItem.rightBarButtonItem = updateBarButton
        if #available(macCatalyst 11.3, *) {
            navigationItem.leftBarButtonItem = closeBarButton
        }

        viewModel.doProfileSettingsForm(request: .init())
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        self.dismissWithExitButton(presses: presses)
    }
    
    @objc private func updateBarButtonTapped() {
        setNewBarButton(loading: true)
        viewModel.doRemoteProfileSettingsUpdate(request: .init(data: tableFormData))
    }
        
    @objc private func dismissSelf() {
        dismiss(animated: true)
    }
    
    private func setNewBarButton(loading: Bool) {
        let button: UIBarButtonItem = loading ? loadingBarButton : updateBarButton
        navigationItem.rightBarButtonItem = button
    }
}

extension ProfileSettingsViewController: ProfileSettingsViewControllerProtocol {

    func displayProfileSettingsForm(viewModel: ProfileSettings.ProfileSettingsForm.ViewModel) {
        tableFormData.bio = viewModel.bio
        tableFormData.displayName = viewModel.displayName
        tableFormData.email = viewModel.email
        tableFormData.matrix = viewModel.matrix
        tableFormData.showNsfwContent = viewModel.nsfwContent
        tableFormData.sendNotificationsToEmail = viewModel.notifToEmail
        
        profileSettingsView?.configure(viewModel: getNewTableData(viewModel: viewModel))
    }
    
    func displayLoadingIndicator(viewModel: ProfileSettings.LoadingIndicator.ViewModel) {
        viewModel.isLoading
            ? profileSettingsView?.showLoadingIndicator()
            : profileSettingsView?.hideLoadingIndicator()
    }
    
    func displayError(viewModel: ProfileSettings.SomeError.ViewModel) {
        setNewBarButton(loading: false)
        profileSettingsView?.hideLoadingIndicator()
        UIAlertController.createOkAlert(
            message: viewModel.error,
            completion: {
                [weak self] in

                if viewModel.exitImmediately {
                    self?.dismissSelf()
                }
            }
        )
    }
    
    func displaySuccessUpdatingSetting() {
        setNewBarButton(loading: false)
        dismissSelf()
    }
    
    private func updateTableViewModel() {
        let viewModel = getNewTableData(
            viewModel: .init(
                displayName: tableFormData.displayName,
                bio: tableFormData.bio,
                email: tableFormData.email,
                matrix: tableFormData.matrix,
                nsfwContent: tableFormData.showNsfwContent,
                notifToEmail: tableFormData.sendNotificationsToEmail

            )
        )
        
        profileSettingsView?.updateData(viewModel: viewModel)
    }
    
    private func getNewTableData(viewModel: ProfileSettings.ProfileSettingsForm.ViewModel) -> SettingsTableViewModel {
        let displayNameCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableFormType.displayName.rawValue,
            type: .input(
                options: .init(
                    valueText: viewModel.displayName,
                    placeholderText: "profile-display-name-hint".localized,
                    isEnabled: true,
                    capitalization: .none,
                    autocorrection: .no
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
                    capitalization: .none,
                    autocorrection: .no
                ))
        )
        
        let matrixCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableFormType.matrix.rawValue,
            type: .input(
                options: .init(
                    valueText: viewModel.matrix,
                    placeholderText: "profile-matrix-hint".localized,
                    isEnabled: true,
                    capitalization: .none,
                    autocorrection: .no
                ))
        )
        
        let changePasswordCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableFormType.changePassword.rawValue,
            type: .rightDetail(
                options: .init(
                    title: .init(text: "profile-new-password-hint".localized),
                    detailType: .label(text: "")
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
                cells: [changePasswordCell],
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
        handleTextField(uniqueIdentifier: uniqueIdentifier, text: text)
    }
    
    func settingsCell(
        elementView: UITextView,
        didReportTextChange text: String,
        identifiedBy uniqueIdentifier: UniqueIdentifierType?
    ) {
        handleTextField(uniqueIdentifier: uniqueIdentifier, text: text)
    }
    
    func settingsTableView(
        _ tableView: SettingsTableView,
        didSelectCell cell: SettingsTableSectionViewModel.Cell,
        at indexPath: IndexPath
    ) {
        if cell.uniqueIdentifier == TableFormType.changePassword.rawValue {
            let assembly = ProfileChangePasswordAssembly()
            let module = assembly.makeModule()
            navigationController?.pushViewController(module, animated: true)
        }
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
        default: break
        }
        
        // safe changes
        updateTableViewModel()
    }
}

extension ProfileSettingsViewController: StyledNavigationControllerPresentable {
    var navigationBarAppearanceOnFirstPresentation: StyledNavigationController.NavigationBarAppearanceState {
        .pageSheetAppearance()
    }
}
