//
//  CreateCommunityViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 28.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol CreateCommunityViewControllerProtocol: AnyObject {
    func displayCreateCommunityForm(viewModel: CreateCommunity.CreateCommunityFormLoad.ViewModel)
    func displaySuccessCreatingCommunity(viewModel: CreateCommunity.SuccessCreateCommunity.ViewModel)
    func displayErrorCreatingCommunity(viewModel: CreateCommunity.ErrorCreateCommunity.ViewModel)
}

extension CreateCommunityViewController {
    // MARK: - Inner Types
    enum FormField: String {
        case name, displayName, icon, banner, sidebar, nsfwOption
        
        init?(uniqueIdentifier: UniqueIdentifierType) {
            if let value = FormField(rawValue: uniqueIdentifier) {
                self = value
            } else {
                return nil
            }
        }
    }
    
    struct FormData {
        var name: String?
        var displayName: String?
        var sidebar: String?
        var icon: String?
        var banner: String?
        var nsfwOption: Bool
    }
}

class CreateCommunityViewController: UIViewController, CatalystDismissProtocol {
    
    // MARK: - Properties
    weak var coordinator: CreateCommunityCoordinator?
    private let viewModel: CreateCommunityViewModelProtocol
    
    lazy var createCommunityView = self.view as! CreateCommunityUI
    
    lazy var styledNavController = self.navigationController as! StyledNavigationController
    
    lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        return picker
    }()
    
    private lazy var createBarButton = UIBarButtonItem(
        title: "action-create".localized.uppercased(),
        style: .done,
        target: self,
        action: #selector(createBarButtonTapped(_:))
    )
    
    private var currentImagePick: CreateCommunityImagesCell.ImagePick?
    
    private var createComminityData: FormData = {
        .init(
            name: nil,
            displayName: nil,
            sidebar: nil,
            icon: nil,
            banner: nil,
            nsfwOption: false
        )
    }()
    
    init(
        viewModel: CreateCommunityViewModelProtocol
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrided
    override func loadView() {
        let view = CreateCommunityUI()
        view.delegate = self
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.styledNavController.setNeedsNavigationBarAppearanceUpdate(sender: self)
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.doCreateCommunityFormLoad(request: .init())
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        self.dismissWithExitButton(presses: presses)
    }
    
    // MARK: - Actions
    
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = createBarButton
        title = "create-content-create-community".localized
    }
    
    @objc private func createBarButtonTapped(_ sender: UIBarButtonItem) {
        guard let nameText = createComminityData.name?.lowercased() else {
            UIAlertController.createOkAlert(message: "create-content-name-error".localized)
            return
        }
        guard let displayNameText = createComminityData.displayName else {
            UIAlertController.createOkAlert(message: "create-content-title-error".localized)
            return
        }
        var descriptionText = createComminityData.sidebar
        let iconText = createComminityData.icon
        let bannerText = createComminityData.banner
        let nsfwOption = createComminityData.nsfwOption
        
        if descriptionText == "" {
            descriptionText = nil
        }
        
        self.viewModel.doRemoteCreateCommunity(
            request:
                .init(
                    name: nameText,
                      displayName: displayNameText,
                      sidebar: descriptionText,
                      icon: iconText,
                      banner: bannerText,
                      nsfwOption: nsfwOption
                )
            )
    }
}

extension CreateCommunityViewController: CreateCommunityViewControllerProtocol {
    // swiftlint:disable:next function_body_length
    func displayCreateCommunityForm(viewModel: CreateCommunity.CreateCommunityFormLoad.ViewModel) {
        let nameCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: FormField.name.rawValue,
            type: .input(
                options: .init(
                    valueText: createComminityData.name,
                    placeholderText: "johnappleseed",
                    shouldAlwaysShowPlaceholder: false,
                    inputGroup: "name",
                    capitalization: .none
                )
            )
        )
        
        let displayNameCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: FormField.displayName.rawValue,
            type: .input(
                options: .init(
                    valueText: createComminityData.displayName,
                    placeholderText: "John Appleseed",
                    shouldAlwaysShowPlaceholder: false,
                    inputGroup: "displayName"
                )
            )
        )
                
        // TODO: add icon and banner cells
        
        let sidebarCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: FormField.sidebar.rawValue,
            type: .largeInput(
                options: .init(
                    valueText: createComminityData.sidebar,
                    placeholderText: "create-content-community-description-placeholder".localized,
                    maxLength: nil
                )
            )
        )
        
        let nsfwCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: FormField.nsfwOption.rawValue,
            type: .rightDetail(
                options: .init(
                    title: .init(text: "create-content-create-nsfw".localized),
                    detailType: .switch(
                        .init(isOn: self.createComminityData.nsfwOption)
                    ),
                    accessoryType: .none
                )
            )
        )
        
        let sectionsViewModel: [SettingsTableSectionViewModel] = [
            .init(
                header: .init(title: "create-content-community-name".localized),
                cells: [nameCell],
                footer: .init(description: "create-content-community-name-description".localized)
            ),
            .init(
                header: .init(title: "create-content-community-display-name".localized),
                cells: [displayNameCell],
                footer: .init(description: "create-content-community-display-name-description".localized)
            ),
            .init(
                header: .init(title: "create-content-community-description".localized),
                cells: [sidebarCell],
                footer: nil
            ),
            .init(
                header: nil,
                cells: [nsfwCell],
                footer: nil
            )
        ]
        
        self.createCommunityView.configure(
            viewModel: SettingsTableViewModel(sections: sectionsViewModel)
        )
    }
    
    func displaySuccessCreatingCommunity(viewModel: CreateCommunity.SuccessCreateCommunity.ViewModel) {
        self.coordinator?.goToCommunity(comm: viewModel.community)
    }
    
    func displayErrorCreatingCommunity(viewModel: CreateCommunity.ErrorCreateCommunity.ViewModel) {
        UIAlertController.createOkAlert(message: viewModel.error)
    }
}

extension CreateCommunityViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
//        if let _ = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//          customView.onPickedImage?(image, currentImagePick!)
//        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension CreateCommunityViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        let alertControl = UIAlertController.Configurations.reallyWantToExit(
            onYes: {
                self.dismiss(animated: true, completion: nil)
            }
        )
        
        present(alertControl, animated: true, completion: nil)
    }
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return false
    }
}

extension CreateCommunityViewController: CreateCommunityViewDelegate {
    func settingsCell(
        elementView: UITextView,
        didReportTextChange text: String,
        identifiedBy uniqueIdentifier: UniqueIdentifierType?
    ) {
        self.handleTextField(uniqueType: uniqueIdentifier, text: text)
    }
    
    func settingsCell(
        elementView: UITextField,
        didReportTextChange text: String?,
        identifiedBy uniqueIdentifier: UniqueIdentifierType?
    ) {
        self.handleTextField(uniqueType: uniqueIdentifier, text: text)
    }
    
    func settingsCell(
        _ cell: SettingsRightDetailSwitchTableViewCell,
        switchValueChanged isOn: Bool
    ) {
        self.createComminityData.nsfwOption = isOn
    }
    
    private func handleTextField(uniqueType: UniqueIdentifierType?, text: String?) {
        guard let uniqueId = uniqueType,
              let field = FormField(rawValue: uniqueId)
        else { return }
        
        switch field {
        case .name:
            self.createComminityData.name = text
        case .displayName:
            self.createComminityData.displayName = text
        case .sidebar:
            self.createComminityData.sidebar = text
        default: break
        }
    }    
}

// MARK: - CreateCommunityViewController: StyledNavigationControllerPresentable -
extension CreateCommunityViewController: StyledNavigationControllerPresentable {
    var navigationBarAppearanceOnFirstPresentation: StyledNavigationController.NavigationBarAppearanceState {
        .pageSheetAppearance()
    }
}
