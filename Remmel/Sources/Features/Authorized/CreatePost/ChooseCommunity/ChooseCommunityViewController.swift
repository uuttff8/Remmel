//
//  ChooseCommunityViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 22.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMModels

protocol ChooseCommunityViewControllerProtocol: AnyObject {
    func displayCommunities(viewModel: ChooseCommunity.CommunitiesLoad.ViewModel)
    func displaySearchResults(viewModel: ChooseCommunity.SearchCommunities.ViewModel)
}

class ChooseCommunityViewController: UIViewController {
    weak var coordinator: CreatePostCoordinator?
    private let viewModel: ChooseCommunityViewModelProtocol

    var onCommunitySelected: ((RMModels.Views.CommunityView) -> Void)?
    
    lazy var chooseCommunityView = self.view as? ChooseCommunityUI
    
    let tableManager = ChooseCommunityTableDataSource()

    override func loadView() {
        tableManager.delegate = self
        let view = ChooseCommunityUI(tableManager: tableManager)
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
        self.viewModel.doCommunitiesLoad(request: .init())
    }
}

extension ChooseCommunityViewController: ChooseCommunityViewControllerProtocol {
    func displayCommunities(viewModel: ChooseCommunity.CommunitiesLoad.ViewModel) {
        guard case let .result(data) = viewModel.state else {
            return
        }
        
        tableManager.viewModels = data
        chooseCommunityView?.updateTableViewData(dataSource: tableManager)
    }
    
    func displaySearchResults(viewModel: ChooseCommunity.SearchCommunities.ViewModel) {
        guard case let .result(data) = viewModel.state else {
            return
        }

        tableManager.filteredViewModels = data
        chooseCommunityView?.updateTableViewData(dataSource: tableManager)
    }
}

extension ChooseCommunityViewController: ChooseCommunityTableDataSourceDelegate {
    func tableDidSelect(community: RMModels.Views.CommunityView) {
        onCommunitySelected?(community)
        navigationController?.popViewController(animated: true)
    }
    
    func tableShowNotFound() {
        chooseCommunityView?.hideNotFound()
    }
}

extension ChooseCommunityViewController: ChooseCommunityUIDelegate {
    func chooseView(_ chooseView: ChooseCommunityUI, didRequestSearch query: String) {
        viewModel.doSearchCommunities(request: .init(query: query))
    }
}

// MARK: - CreatePostScreenViewController: StyledNavigationControllerPresentable -
extension ChooseCommunityViewController: StyledNavigationControllerPresentable {
    var navigationBarAppearanceOnFirstPresentation: StyledNavigationController.NavigationBarAppearanceState {
        .pageSheetAppearance()
    }
}
