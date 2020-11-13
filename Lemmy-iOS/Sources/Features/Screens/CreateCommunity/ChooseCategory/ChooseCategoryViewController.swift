//
//  ChooseCategoryViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 29.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class ChooseCategoryViewController: UIViewController {

    weak var coordinator: CreateCommunityCoordinator?

    let customView: ChooseCategoryUI
    let model: CreateCommunityModel

    override func loadView() {
        self.view = customView
    }

    init(model: CreateCommunityModel) {
        self.model = model
        self.customView = ChooseCategoryUI(model: model)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if model.categories.value == [] {
            model.loadCategories()
        }

        customView.dismissView = {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
