//
//  CreatePostViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 20.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Photos

// MARK: CreatePostScreenViewControllerProtocol: AnyObject -

protocol CreatePostScreenViewControllerProtocol: AnyObject {
    func displayCreatingPost(viewModel: CreatePost.CreatePostLoad.ViewModel)
    func displaySuccessCreatingPost(viewModel: CreatePost.RemoteCreatePost.ViewModel)
    func displayBlockingActivityIndicator(viewModel: CreatePost.BlockingWaitingIndicatorUpdate.ViewModel)
    func displayCreatePostError(viewModel: CreatePost.CreatePostError.ViewModel)
    func displayUrlLoadImage(viewModel: CreatePost.RemoteLoadImage.ViewModel)
    func displayErrorUrlLoadImage(viewModel: CreatePost.ErrorRemoteLoadImage.ViewModel)
}

// MARK: - Appearance -

extension CreatePostScreenViewController {
    struct Appearance {
        let navBarAppearance: StyledNavigationController.NavigationBarAppearanceState = .pageSheetAppearance()
    }
}

// MARK: - CreatePostScreenViewController: UIViewController -

class CreatePostScreenViewController: UIViewController, CatalystDismissProtocol {
    // MARK: - Properties
    
    let appearance: Appearance
    
    weak var coordinator: CreatePostCoordinator?
    private let viewModel: CreatePostViewModelProtocol
    
    lazy var createPostView = self.view as? CreatePostScreenUI
    lazy var styledNavController = self.navigationController as? StyledNavigationController
    
    // TODO: refactor this
    private var inputWithImageCell: SettingsInputWithImageTableViewCell?
        
    private let predefinedCommunity: LMModels.Views.CommunityView?
    
    private var createPostData: FormData = {
        .init(
            communityView: nil,
            title: nil,
            body: nil,
            url: nil,
            nsfwOption: false
        )
    }()
            
    private lazy var postBarButton = UIBarButtonItem(
        title: "action-create".localized.uppercased(),
        style: .done,
        target: self,
        action: #selector(postBarButtonTapped(_:))
    )
    
    @available(macCatalyst 11.3, *)
    private lazy var closeBarButton = UIBarButtonItem(
        barButtonSystemItem: .close,
        target: self,
        action: #selector(dismissSelf)
    )
        
    private lazy var imagePickerController: UIImagePickerController = {
        $0.delegate = self
        $0.allowsEditing = false
        $0.sourceType = .photoLibrary
        return $0
    }(UIImagePickerController())
    
    init(
        viewModel: CreatePostViewModelProtocol,
        predefinedCommunity: LMModels.Views.CommunityView? = nil,
        appearance: Appearance = Appearance()
    ) {
        self.viewModel = viewModel
        self.predefinedCommunity = predefinedCommunity
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
        
        if let predefCommunity = predefinedCommunity {
            createPostData.communityView = predefCommunity
        }
        
        setupNavigationItem()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.doCreatePostLoad(request: .init())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        styledNavController?.setNeedsNavigationBarAppearanceUpdate(sender: self)
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        dismissWithExitButton(presses: presses)
    }
        
    // MARK: - Private API
    
    private func setupNavigationItem() {
        self.title = "create-content-create-post".localized
        navigationItem.rightBarButtonItem = postBarButton
        if #available(macCatalyst 11.3, *) {
            navigationItem.leftBarButtonItem = closeBarButton
        }
    }
    
    // MARK: - Inner Types
    enum FormField: String {
        case community, url, title, body, nsfw
        
        var title: String {
            switch self {
            case .community: return "create-content-community".localized
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
        var communityView: LMModels.Views.CommunityView?
        var title: String?
        var body: String?
        var url: String?
        var nsfwOption: Bool
    }
    
    // MARK: - Action
    @available(macCatalyst 11.3, *)
    @objc func dismissSelf() {
        self.dismiss(animated: true)
    }
    
    @objc private func postBarButtonTapped(_ sender: UIBarButtonItem) {
        guard let communityId = self.createPostData.communityView?.id else {
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
                body: createPostData.body,
                url: createPostData.url,
                nsfw: createPostData.nsfwOption
            )
        )
    }
    
    private func handleTextField(uniqueIdentifier: UniqueIdentifierType?, text: String?) {
        guard let id = uniqueIdentifier, let field = FormField(uniqueIdentifier: id) else {
            return
        }
        
        switch field {
        case .title:
            createPostData.title = text
        case .body:
            createPostData.body = text
        case .url:
            createPostData.url = text
        default: break
        }
        
        updateTableViewModel()
    }
    
    private func updateUrlState(
        for cell: SettingsInputWithImageTableViewCell, state: SettingsInputWithImageCellView.UrlState
    ) {
        // to update data
        defer {
            self.updateTableViewModel()
        }
        print("update for state: \(state)")
        cell.urlState = state
        
        self.inputWithImageCell = cell
        
        switch state {
        case .notAdded:
            cell.elementView.hideLoading()
            self.present(imagePickerController, animated: true)
        case .loading:
            cell.elementView.showLoading()
            cell.elementView.textFieldIsEnabled = false
            cell.elementView.title = nil
            cell.elementView.imageIcon = Config.Image.close
        case .addWithImage(let text):
            cell.elementView.hideLoading()
            cell.elementView.textFieldIsEnabled = false
            cell.elementView.title = text
            cell.elementView.imageIcon = Config.Image.close
            cell.urlState = .urlAdded
            self.createPostData.url = text
        case .urlAdded:
            cell.elementView.textFieldIsEnabled = true
            cell.elementView.title = nil
            cell.elementView.imageIcon = Config.Image.addImage
            cell.urlState = .notAdded // for future presenting
            self.createPostData.url = nil
        case .error:
            cell.urlState = .notAdded
            cell.elementView.hideLoading()
            cell.elementView.textFieldIsEnabled = true
            cell.elementView.title = nil
            cell.elementView.imageIcon = Config.Image.addImage
            self.createPostData.url = nil
        }
    }
}

extension CreatePostScreenViewController: CreatePostScreenViewControllerProtocol {
    func displayUrlLoadImage(viewModel: CreatePost.RemoteLoadImage.ViewModel) {
        guard let inputWithImageCell = inputWithImageCell else {
            return
        }
        updateUrlState(for: inputWithImageCell, state: .addWithImage(text: viewModel.url))
    }
    
    func displayErrorUrlLoadImage(viewModel: CreatePost.ErrorRemoteLoadImage.ViewModel) {
        guard let inputWithImageCell = inputWithImageCell else {
            return
        }
        
        UIAlertController.createOkAlert(message: "Some error happened when uploading a picture")
        updateUrlState(for: inputWithImageCell, state: .error)
    }
    
    func displayCreatingPost(viewModel: CreatePost.CreatePostLoad.ViewModel) {
        let sectionsViewModel = getTableViewSections()
        createPostView?.configure(viewModel: SettingsTableViewModel(sections: sectionsViewModel))
    }
    
    func updateTableViewModel() {
        let sectionsViewModel = getTableViewSections()
        createPostView?.updateOnlyViewModel(viewModel: SettingsTableViewModel(sections: sectionsViewModel))
    }
    
    private func getTableViewSections() -> [SettingsTableSectionViewModel] {
        // Community choosing
        let chooseCommunityCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: FormField.community.rawValue,
            type: .rightDetail(
                options: .init(
                    title: .init(text: createPostData.communityView?.community.name
                                    ?? "create-content-community".localized),
                    detailType: .label(text: nil),
                    accessoryType: .disclosureIndicator
                )
            )
        )
                
        let urlCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: FormField.url.rawValue,
            type: .inputWithImage(
                options: .init(
                    placeholderText: "create-content-create-url-placeholder".localized,
                    valueText: self.createPostData.url,
                    imageIcon: Config.Image.addImage,
                    autocorrection: .no
                )
            )
        )
        
        let titleCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: FormField.title.rawValue,
            type: .largeInput(
                options: .init(
                    valueText: self.createPostData.title,
                    placeholderText: "create-content-create-title-placeholder".localized,
                    maxLength: nil,
                    noNewline: true
                )
            )
        )
        
        let bodyCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: FormField.body.rawValue,
            type: .largeInput(
                options: .init(
                    valueText: self.createPostData.body,
                    placeholderText: "create-content-create-body-placeholder".localized,
                    maxLength: nil
                )
            )
        )
        
        let nsfwCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: FormField.nsfw.rawValue,
            type: .rightDetail(
                options: .init(
                    title: .init(text: "create-content-create-nsfw".localized),
                    detailType: .switch(
                        .init(isOn: self.createPostData.nsfwOption)
                    ),
                    accessoryType: .none
                )
            )
        )
        
        let sectionsViewModel: [SettingsTableSectionViewModel] = [
            .init(
                header: .init(title: "create-content-choose-community".localized),
                cells: [chooseCommunityCell],
                footer: nil
            ),
            .init(
                header: .init(title: "create-content-create-url".localized),
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

        return sectionsViewModel
    }
    
    func displayBlockingActivityIndicator(viewModel: CreatePost.BlockingWaitingIndicatorUpdate.ViewModel) {
        viewModel.shouldDismiss
            ? createPostView?.hideActivityIndicatorView()
            : createPostView?.showActivityIndicatorView()
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
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
           let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            guard let inputWithImageCell = inputWithImageCell else {
                return
            }
            
            self.updateUrlState(for: inputWithImageCell, state: .loading)
            self.viewModel.doRemoteLoadImage(request: .init(image: image, filename: imageUrl.lastPathComponent))
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
        false
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
            coordinator?.goToChoosingCommunity(
                choosedCommunity: { community in
                    self.createPostData.communityView = community
                }
            )
        default:
            break
        }
        
        updateTableViewModel()
    }
    
    func settingsCellWithImageDidEnterText(
        elementView: SettingsInputWithImageTableViewCell,
        didReportTextChange text: String?
    ) {
        guard let selectedForm = FormField(uniqueIdentifier: elementView.uniqueIdentifier ?? "") else {
            return
        }
        
        switch selectedForm {
        case .url:
            createPostData.url = text
        default:
            break
        }
        
        updateTableViewModel()
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
        handleTextField(uniqueIdentifier: uniqueIdentifier, text: text)
    }
    
    func settingsCell(
        _ cell: SettingsRightDetailSwitchTableViewCell,
        switchValueChanged isOn: Bool
    ) {
        createPostData.nsfwOption = isOn
        updateTableViewModel()
    }
    
    func settingsCellDidTappedToIcon(_ cell: SettingsInputWithImageTableViewCell) {
        updateUrlState(for: cell, state: cell.urlState)
    }
}

// MARK: - CreatePostScreenViewController: StyledNavigationControllerPresentable -
extension CreatePostScreenViewController: StyledNavigationControllerPresentable {
    var navigationBarAppearanceOnFirstPresentation: StyledNavigationController.NavigationBarAppearanceState {
        appearance.navBarAppearance
    }
}
