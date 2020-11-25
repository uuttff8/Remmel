//
//  CreatePostViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 20.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

// MARK: CreatePostScreenViewControllerProtocol: AnyObject -

protocol CreatePostScreenViewControllerProtocol: AnyObject {
    func displayCreatingPost(viewModel: CreatePost.CreatePostLoad.ViewModel)
    func displaySuccessCreatingPost(viewModel: CreatePost.RemoteCreatePost.ViewModel)
    func displayBlockingActivityIndicator(viewModel: CreatePost.BlockingWaitingIndicatorUpdate.ViewModel)
    func displayCreatePostError(viewModel: CreatePost.CreatePostError.ViewModel)
}

// MARK: - Appearance -

extension CreatePostScreenViewController {
    struct Appearance {
        var navBarAppearance: StyledNavigationController.NavigationBarAppearanceState = .pageSheetAppearance()
    }
}

// MARK: - CreatePostScreenViewController: UIViewController -

class CreatePostScreenViewController: UIViewController {
    
    // MARK: - Properties
    
    let appearance: Appearance
    
    weak var coordinator: CreatePostCoordinator?
    private let viewModel: CreatePostViewModelProtocol
    
    lazy var createPostView = self.view as! CreatePostScreenUI
    lazy var styledNavController = self.navigationController as! StyledNavigationController
    
    private var createPostData: FormData = {
        .init(
            community: nil,
            title: nil,
            body: nil,
            url: nil,
            nsfwOption: false
        )
    }()
    
    private lazy var postBarButton = UIBarButtonItem(
        title: "CREATE",
        primaryAction: UIAction(handler: postBarButtonTapped),
        style: .done
    )
    
    private lazy var imagePicker = UIImagePickerController().then {
        $0.delegate = self
        $0.allowsEditing = false
        $0.sourceType = .photoLibrary
    }
    
    init(
        viewModel: CreatePostViewModelProtocol,
        appearance: Appearance = Appearance()
    ) {
        self.viewModel = viewModel
        self.appearance = appearance
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
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.doCreatePostLoad(request: .init())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.styledNavController.setNeedsNavigationBarAppearanceUpdate(sender: self)
    }
    
    // MARK: - Private API
    
    private func setupNavigationItem() {
        self.title = "Create Post"
        navigationItem.rightBarButtonItem = postBarButton
    }
    
    // MARK: - Inner Types
    enum FormField: String {
        case community, url, title, body, nsfw
        
        var title: String {
            switch self {
            case .community: return "Community"
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
    
    struct FormData {
        var community: LemmyModel.CommunityView?
        var title: String?
        var body: String?
        var url: String?
        var nsfwOption: Bool
    }
    
    // MARK: - Action
    private func postBarButtonTapped(_ action: UIAction) {
        guard let communityId = self.createPostData.community?.id else {
            self.displayCreatePostError(viewModel: .init(error: "Community not specified"))
            return
        }
        
        guard let title = self.createPostData.title else {
            self.displayCreatePostError(viewModel: .init(error: "Title not specified"))
            return
        }
        
        self.viewModel.doRemoteCreatePost(
            request: .init(
                communityId: communityId,
                title: title,
                body: self.createPostData.body,
                url: self.createPostData.url,
                nsfw: self.createPostData.nsfwOption
            )
        )
    }
    
    private func handleTextField(uniqueIdentifier: UniqueIdentifierType?, text: String?) {
        guard let id = uniqueIdentifier, let field = FormField(uniqueIdentifier: id) else {
            return
        }
        
        switch field {
        case .title:
            self.createPostData.title = text
        case .body:
            self.createPostData.body = text
        case .url:
            self.createPostData.url = text
        default: break
        }
    }
}

extension CreatePostScreenViewController: CreatePostScreenViewControllerProtocol {
    func displayCreatingPost(viewModel: CreatePost.CreatePostLoad.ViewModel) {
        
        // Community choosing
        let chooseCommunityCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: FormField.community.rawValue,
            type: .rightDetail(
                options: .init(
                    title: .init(text: createPostData.community?.name ?? "Community"),
                    detailType: .label(text: nil),
                    accessoryType: .disclosureIndicator
                )
            )
        )
        
        let urlCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: FormField.url.rawValue,
            type: .input(
                options: .init(
                    valueText: self.createPostData.url ?? nil,
                    placeholderText: "Enter Url",
                    shouldAlwaysShowPlaceholder: false,
                    inputGroup: "url"
                )
            )
        )
        
        let titleCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: FormField.title.rawValue,
            type: .largeInput(
                options: .init(
                    valueText: self.createPostData.title ?? nil,
                    placeholderText: "Your title",
                    maxLength: nil
                )
            )
        )
        
        let bodyCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: FormField.body.rawValue,
            type: .largeInput(
                options: .init(
                    valueText: self.createPostData.body ?? nil,
                    placeholderText: "Your body",
                    maxLength: nil
                )
            )
        )
        
        let nsfwCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: FormField.nsfw.rawValue,
            type: .rightDetail(
                options: .init(
                    title: .init(text: "NSFW"),
                    detailType: .switch(
                        .init(isOn: self.createPostData.nsfwOption)
                    ),
                    accessoryType: .none
                )
            )
        )
        
        let sectionsViewModel: [SettingsTableSectionViewModel] = [
            .init(
                header: .init(title: "Choose Community"),
                cells: [chooseCommunityCell],
                footer: nil
            ),
            .init(
                header: .init(title: "Create Url"),
                cells: [urlCell],
                footer: nil
            ),
            .init(
                header: nil,
                cells: [titleCell, bodyCell],
                footer: nil
            ),
            .init(
                header: nil,
                cells: [nsfwCell],
                footer: nil
            )
        ]
        
        self.createPostView.configure(viewModel: SettingsTableViewModel(sections: sectionsViewModel))
    }
    
    func displayBlockingActivityIndicator(viewModel: CreatePost.BlockingWaitingIndicatorUpdate.ViewModel) {
        viewModel.shouldDismiss
            ? self.createPostView.hideActivityIndicatorView()
            : self.createPostView.showActivityIndicatorView()
    }
    
    func displaySuccessCreatingPost(viewModel: CreatePost.RemoteCreatePost.ViewModel) {
        self.coordinator?.goToPost(post: viewModel.post)
    }
    
    func displayCreatePostError(viewModel: CreatePost.CreatePostError.ViewModel) {
        UIAlertController.createOkAlert(message: viewModel.error)
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
                    self.createPostData.community = community
                }
            )
        default:
            break
        }
    }
    
    func settingsCell(
        elementView: UITextView,
        didReportTextChange text: String,
        identifiedBy uniqueIdentifier: UniqueIdentifierType?
    ) {
        self.handleTextField(uniqueIdentifier: uniqueIdentifier, text: text)
    }
    
    func settingsCell(
        elementView: UITextField,
        didReportTextChange text: String?,
        identifiedBy uniqueIdentifier: UniqueIdentifierType?
    ) {
        self.handleTextField(uniqueIdentifier: uniqueIdentifier, text: text)
    }
    
    func settingsCell(
        _ cell: SettingsRightDetailSwitchTableViewCell,
        switchValueChanged isOn: Bool
    ) {
        self.createPostData.nsfwOption = isOn
    }
}

// MARK: - SettingsViewController: StyledNavigationControllerPresentable -
extension CreatePostScreenViewController: StyledNavigationControllerPresentable {
    var navigationBarAppearanceOnFirstPresentation: StyledNavigationController.NavigationBarAppearanceState {
        self.appearance.navBarAppearance
    }
}
