//
//  CreateCommunityViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 28.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CreateCommunityViewController: UIViewController {
    
    // MARK: - Properties
    weak var coordinator: CreateCommunityCoordinator?
    
    lazy var customView = CreateCommunityUI(model: model)
    let model = CreateCommunityModel()
    
    lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        return picker
    }()
    
    private var currentImagePick: CreateCommunityImagesCell.ImagePick?
    
    // MARK: - Overrided
    override func loadView() {
        self.view = customView
    }
    
    override func viewDidLoad() {
        title = "Create community"
        
        model.loadCategories()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "CREATE",
            primaryAction: UIAction(handler: createBarButtonTapped),
            style: .done
        )
        
        customView.goToChoosingCategory = {
            self.coordinator?.goToChoosingCommunity(model: self.model)
        }
        
        customView.onPickImage = { imagePick in
            self.currentImagePick = imagePick
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    // MARK: Actions
    private func createBarButtonTapped(_ action: UIAction) {
        print("action")
    }
}

extension CreateCommunityViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            customView.onPickedImage?(image, currentImagePick!)
        }

        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
}

extension CreateCommunityViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        let alertControl = UIAlertController(title: nil, message: "Do you really want to exit", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        })
        let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
        alertControl.addAction(yesAction)
        alertControl.addAction(noAction)
        present(alertControl, animated: true, completion: nil)
    }
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return false
    }
}
