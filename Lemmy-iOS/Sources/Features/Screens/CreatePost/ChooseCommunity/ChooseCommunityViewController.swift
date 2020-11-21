//
//  ChooseCommunityViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 22.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol ChooseCommunityViewControllerProtocol: AnyObject {
    func displayCommunities(viewModel: ChooseCommunity.CommunitiesLoad.ViewModel)
    func displaySearchResults(viewModel: ChooseCommunity.SearchCommunities.ViewModel)
}

class ChooseCommunityViewController: UIViewController {
    weak var coordinator: CreatePostCoordinator?
    private let viewModel: ChooseCommunityViewModelProtocol

    lazy var chooseCommunityView = self.view as! ChooseCommunityUI
    
    let tableViewDelegate = ChooseCommunityTableDataSource()

    override func loadView() {
        tableViewDelegate.delegate = self
        let view = ChooseCommunityUI(tableViewDelegate: tableViewDelegate)
        view.delegate = self
        
        self.view = view
    }

    init(viewModel: ChooseCommunityViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        customView.dismissView = {
//            self.navigationController?.popViewController(animated: true)
//        }
    }
}

extension ChooseCommunityViewController: ChooseCommunityTableDataSourceDelegate {
    func tableDidSelect(community: LemmyModel.CommunityView) {
        
    }
    
    func tableShowNotFound() {
        
    }
}

extension ChooseCommunityViewController: ChooseCommunityUIDelegate {
    func chooseView(_ chooseView: ChooseCommunityUI, didRequestSearch query: String) {
        self.viewModel.doSearchCommunities(request: .init(query: query))
    }
}
