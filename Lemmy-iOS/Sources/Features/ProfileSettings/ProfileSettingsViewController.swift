//
//  ProfileSettingsViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 03.02.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol ProfileSettingsViewControllerProtocol: AnyObject {
    func displayProfileSettingsForm(request: ProfileSettings.ProfileSettingsForm.ViewModel)
}

final class ProfileSettingsViewController: UIViewController {
    
    enum TableForm: String {
        case displayName
        case bio
        case email
        case matrix
        case newPassword
        case verifyPassword
        case oldPassword
        case showNsfwContent
        case showAvatars
        case sendNotificationsToEmail
    }
    
    private let viewModel: ProfileSettingsViewModelProtocol
    
    private lazy var profileSettingsView = self.view as! ProfileSettingsView
    
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
        self.viewModel.doProfileSettingsForm(request: .init())
    }
}

extension ProfileSettingsViewController: ProfileSettingsViewControllerProtocol {
    // swiftlint:disable function_body_length
    func displayProfileSettingsForm(request: ProfileSettings.ProfileSettingsForm.ViewModel) {
        let displayNameCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableForm.displayName.rawValue,
            type: .input(
                options: .init(
                    valueText: "",
                    placeholderText: "Display name",
                    isEnabled: true,
                    capitalization: .none
                ))
        )
        
        let bioCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableForm.displayName.rawValue,
            type: .largeInput(
                options: .init(
                    valueText: "",
                    placeholderText: "Your bio"
                ))
        )
        
        let emailCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableForm.displayName.rawValue,
            type: .input(
                options: .init(
                    valueText: "",
                    placeholderText: "Email",
                    isEnabled: true,
                    capitalization: .none
                ))
        )
        
        let matrixCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableForm.displayName.rawValue,
            type: .input(
                options: .init(
                    valueText: "",
                    placeholderText: "Matrix link",
                    isEnabled: true,
                    capitalization: .none
                ))
        )
        
        let newPasswordCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableForm.displayName.rawValue,
            type: .input(
                options: .init(
                    placeholderText: "New password",
                    isEnabled: true,
                    capitalization: .none
                ))
        )
        
        let verifyPasswordCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableForm.displayName.rawValue,
            type: .input(
                options: .init(
                    placeholderText: "Repeat password",
                    isEnabled: true,
                    capitalization: .none
                ))
        )
        
        let oldPasswordCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableForm.displayName.rawValue,
            type: .input(
                options: .init(
                    placeholderText: "Old password",
                    isEnabled: true,
                    capitalization: .none
                ))
        )
        
        let nsfwContentCheck = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableForm.displayName.rawValue,
            type: .rightDetail(
                options: .init(
                    title: .init(text: "Show NSFW content"),
                    detailType: .switch(.init(isOn: true))
                ))
        )
        
        let sendNotifToEmailCheck = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableForm.displayName.rawValue,
            type: .rightDetail(
                options: .init(
                    title: .init(text: "Send notifications to email"),
                    detailType: .switch(.init(isOn: true))
                ))
        )
        
        let sectionsViewModel: [SettingsTableSectionViewModel] = [
            .init(
                header: .init(title: "Display name".localized),
                cells: [displayNameCell],
                footer: nil
            ),
            .init(
                header: .init(title: "Bio".localized),
                cells: [bioCell],
                footer: nil
            ),
            .init(
                header: .init(title: "Email And Matrix".localized),
                cells: [emailCell, matrixCell],
                footer: nil
            ),
            .init(
                header: .init(title: "Password".localized),
                cells: [newPasswordCell, verifyPasswordCell, oldPasswordCell],
                footer: .init(description: "If setting a new password, you need all 3 password fields")
            ),
            .init(
                header: nil,
                cells: [nsfwContentCheck, sendNotifToEmailCheck],
                footer: nil
            )
        ]
        
        self.profileSettingsView.configure(viewModel: SettingsTableViewModel(sections: sectionsViewModel))
    }
}

extension ProfileSettingsViewController: ProfileSettingsViewDelegate {
}
