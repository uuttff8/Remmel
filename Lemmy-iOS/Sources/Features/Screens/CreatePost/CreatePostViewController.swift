//
//  CreatePostViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 20.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol CreatePostScreenViewControllerProtocol: AnyObject {
    func displayCreatingPost(viewModel: CreatePost.CreatePostLoad.ViewModel)
    func displayChoosingCommunityForm(viewModel: CreatePost.ChooseCommunityFormPresentation.ViewModel)
}

extension CreatePostScreenViewController {
    struct Appearance {
        var navBarAppearance: StyledNavigationController.NavigationBarAppearanceState = .pageSheetAppearance()
    }
}

class CreatePostScreenViewController: UIViewController {
    
    // MARK: - Properties
    weak var coordinator: CreatePostCoordinator?
    private let viewModel: CreatePostViewModelProtocol
    
    lazy var createPostView = self.view as! CreatePostScreenUI
    lazy var styledNavController = self.navigationController as! StyledNavigationController
    
    let appearance: Appearance
    
    private lazy var imagePicker = UIImagePickerController().then {
        $0.delegate = self
        $0.allowsEditing = false
        $0.sourceType = .photoLibrary
    }
    
    init(viewModel: CreatePostViewModelProtocol, appearance: Appearance = Appearance()) {
        self.appearance = appearance
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrided
    override func loadView() {
        let view = CreatePostScreenUI(frame: UIScreen.main.bounds)
        view.delegate = self
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        self.setupNavigationItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.doCreatePostLoad(request: .init())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateNavigationBarAppearance()
    }
    
    // MARK: - Private API
    
    private func setupNavigationItem() {
        self.title = "Create Community"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "POST",
            primaryAction: UIAction(handler: postBarButtonTapped),
            style: .done
        )
    }
    
    private func updateNavigationBarAppearance() {
        self.styledNavController.setNeedsNavigationBarAppearanceUpdate(sender: self)
        self.styledNavController.setDefaultNavigationBarAppearance(self.appearance.navBarAppearance)
    }
    
    // MARK: - Inner Types
    enum FormField: String {
        case community, url, title, body, nsfw
        
        var title: String {
            switch self {
            case .community: return "Choose community"
            case .url: return "url for your post"
            case .title: return "Title for your post. Required."
            case .body: return "Body for your post. Optional"
            case .nsfw: return "NSFW"
            }
        }
        
        init?(uniqueIdentifier: UniqueIdentifierType) {
            if let value = FormField(rawValue: uniqueIdentifier) {
                self = value
            } else {
                return nil
            }
        }
    }
    
    // MARK: - Action
    private func postBarButtonTapped(_ action: UIAction) {
        // TODO: make request
    }
}

extension CreatePostScreenViewController: CreatePostScreenViewControllerProtocol {
    func displayCreatingPost(viewModel: CreatePost.CreatePostLoad.ViewModel) {
        // Community choosing
        let chooseCommunityCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: FormField.community.rawValue,
            type: .rightDetail(
                options: .init(
                    title: .init(text: FormField.community.title),
                    detailType: .label(text: viewModel.viewModel.community?.name ?? ""),
                    accessoryType: .disclosureIndicator
                )
            )
        )
        
        let sectionsViewModel: [SettingsTableSectionViewModel] = [
            .init(
                header: .init(title: "Choose Community"),
                cells: [chooseCommunityCell],
                footer: nil
            )
        ]
        
        self.createPostView.configure(viewModel: SettingsTableViewModel(sections: sectionsViewModel))
    }
    
    func displayChoosingCommunityForm(viewModel: CreatePost.ChooseCommunityFormPresentation.ViewModel) {
        
    }
    
    // MARK: Private Helpers
    
    private func displaySelectionList(
        formFieldDescription: CreatePost.FormFieldDescription,
        title: String? = nil,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        onSettingSelected: ((CreatePost.FormFieldDescription.FormField) -> Void)? = nil
    ) {
        let selectedCellViewModel: SelectItemViewModel.Section.Cell? = {
            if let currentSetting = formFieldDescription.currentField {
                return .init(uniqueIdentifier: currentSetting.uniqueIdentifier, title: currentSetting.title)
            }
            return nil
        }()
        
        let viewController = SelectItemTableViewController(
            style: .insetGrouped,
            viewModel: .init(
                sections: [
                    .init(
                        cells: formFieldDescription.fields.map {
                            .init(uniqueIdentifier: $0.uniqueIdentifier, title: $0.title)
                        },
                        headerTitle: headerTitle,
                        footerTitle: footerTitle
                    )
                ],
                selectedCell: selectedCellViewModel
            ),
            onItemSelected: { selectedCellViewModel in
                let selectedSetting = CreatePost.FormFieldDescription.FormField(
                    uniqueIdentifier: selectedCellViewModel.uniqueIdentifier,
                    title: selectedCellViewModel.title
                )
                onSettingSelected?(selectedSetting)
            }
        )
        
        viewController.title = title
        
        self.push(module: viewController)
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate -
extension CreatePostScreenViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        if (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) != nil {
            //            customView.onPickedImage?(image)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIAdaptivePresentationControllerDelegate -
extension CreatePostScreenViewController: UIAdaptivePresentationControllerDelegate {
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

extension CreatePostScreenViewController: CreatePostViewDelegate {
    func settingsTableView(
        _ tableView: SettingsTableView,
        didSelectCell cell: SettingsTableSectionViewModel.Cell,
        at indexPath: IndexPath
    ) {
        guard let selectedForm = FormField(uniqueIdentifier: cell.uniqueIdentifier) else {
            return
        }
        
        switch selectedForm {
        case .community:
            self.coordinator?.goToChoosingCommunity(
                choosedCommunity: { (community) in
                    self.viewModel.doChoosingCommunityUpdate(
                        request: .init(community: community)
                    )
                }
            )
        default:
            break
        }
    }
}

// MARK: - SettingsViewController: StyledNavigationControllerPresentable -
extension CreatePostScreenViewController: StyledNavigationControllerPresentable {
    var navigationBarAppearanceOnFirstPresentation: StyledNavigationController.NavigationBarAppearanceState {
        self.appearance.navBarAppearance
    }
}
