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
}

class CreateCommunityViewController: UIViewController {

    // MARK: - Properties
    weak var coordinator: CreateCommunityCoordinator?
    private let viewModel: CreateCommunityViewModelProtocol

    lazy var createCommunityView = self.view as! CreateCommunityUI

    lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        return picker
    }()
    
    private lazy var createBarButton = UIBarButtonItem(
        title: "CREATE",
        primaryAction: UIAction(handler: createBarButtonTapped),
        style: .done
    )

    private var currentImagePick: CreateCommunityImagesCell.ImagePick?

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
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()

//        customView.goToChoosingCategory = {
//            self.coordinator?.goToChoosingCommunity(model: self.model)
//        }
//
//        customView.onPickImage = { imagePick in
//            self.currentImagePick = imagePick
//            self.present(self.imagePicker, animated: true, completion: nil)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.doCreateCommunityFormLoad(request: .init())
    }

    // MARK: Actions
    
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = createBarButton
        title = "Create community"
    }
    
    private func createBarButtonTapped(_ action: UIAction) {
//        let category = model.selectedCategory.value
//        guard let nameText = customView.nameCell.nameTextField.text?.lowercased() else {
//            UIAlertController.createOkAlert(message: "Please name your community")
//            return
//        }
//        guard let titleText = customView.displayNameCell.nameTextField.text else {
//            UIAlertController.createOkAlert(message: "Please title your community")
//            return
//        }
//        var descriptionText = customView.sidebarCell.sidebarTextView.text
//        let iconText = customView.imagesCell.iconImageString
//        let bannerText = customView.imagesCell.bannerImageString
//        let nsfwOption = customView.nsfwCell.customView.switcher.isOn
//
//        if descriptionText == "" {
//            descriptionText = nil
//        }
//
//        let data = CreateCommunityModel.CreateCommunityData(
//            name: nameText,
//            title: titleText,
//            description: descriptionText,
//            icon: iconText,
//            banner: bannerText,
//            categoryId: category?.id,
//            nsfwOption: nsfwOption
//        )
//
//        model.createCommunity(data: data) { (res) in
//            switch res {
//            case .success(let community):
//                DispatchQueue.main.async {
//                    self.coordinator?.goToCommunity(comm: community)
//                }
//            case .failure(let error):
//                DispatchQueue.main.async {
//                    UIAlertController.createOkAlert(message: error.description)
//                }
//            }
//        }
    }
}

extension CreateCommunityViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            customView.onPickedImage?(image, currentImagePick!)
        }

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

extension CreateCommunityViewController: CreateCommunityViewControllerProtocol {
    func displayCreateCommunityForm(viewModel: CreateCommunity.CreateCommunityFormLoad.ViewModel) {
        
    }
}
