//
//  ChooseCategoryViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 29.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class ChooseCategoryViewController: UIViewController {
    
    lazy var chooseCategoryView = self.view as! ChooseCategoryUI
    let viewModel = ChooseCategoryViewModel()
    
    var selectedCategory: ((LMModels.Source.Category) -> Void)?

    override func loadView() {
        let view = ChooseCategoryUI(model: viewModel)
        self.view = view
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.selectedCategory
            .compactMap { $0 }
            .sink { (category) in
                self.selectedCategory?(category)
            }.store(in: &chooseCategoryView.cancellable)
        
        if viewModel.categories.value == [] {
            viewModel.loadCategories()
        }

        chooseCategoryView.dismissView = {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - CreatePostScreenViewController: StyledNavigationControllerPresentable -
extension ChooseCategoryViewController: StyledNavigationControllerPresentable {
    var navigationBarAppearanceOnFirstPresentation: StyledNavigationController.NavigationBarAppearanceState {
        .pageSheetAppearance()
    }
}
