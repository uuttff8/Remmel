//
//  ChooseCommunityViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 22.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class ChooseCommunityViewController: UIViewController {

    weak var coordinator: CreatePostCoordinator?
    
    var communitySelected: ((LemmyApiStructs.CommunityView) -> Void)?
    let customView: ChooseCommunityUI
    let model: CreatePostScreenModel
    
    override func loadView() {
        self.view = customView
    }
    
    init(model: CreatePostScreenModel) {
        self.model = model
        self.customView = ChooseCommunityUI(model: model)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.loadCommunities()
        customView.dismissView = {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
