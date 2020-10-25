//
//  CreatePostViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 20.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CreatePostScreenViewController: UIViewController {
    
    // MARK: - Properties
    weak var coordinator: CreatePostCoordinator?
    
    lazy var customView = CreatePostScreenUI(model: model)
    let model = CreatePostScreenModel()
    
    let imagePicker = UIImagePickerController()
    
    // MARK: - Overrided
    override func loadView() {
        self.view = customView
    }
    
    override func viewDidLoad() {
        title = "Create post"
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        customView.onPickImage = {
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        customView.goToChoosingCommunity = { [self] in
            coordinator?.goToChoosingCommunity(model: model)
        }
    }
}

extension CreatePostScreenViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            customView.onPickedImage?(image)
        }

        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
}
