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

    var onCommunitySelected: ((LemmyModel.CommunityView) -> Void)?
    
    lazy var chooseCommunityView = self.view as! ChooseCommunityUI
    
    let tableViewDataSource = ChooseCommunityTableDataSource()

    override func loadView() {
        tableViewDataSource.delegate = self
        let view = ChooseCommunityUI(tableViewDelegate: tableViewDataSource)
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
        guard case let .result(data) = viewModel.state else { return }
        
        self.tableViewDataSource.viewModels = data
        self.chooseCommunityView.updateTableViewData(dataSource: self.tableViewDataSource)
    }
    
    func displaySearchResults(viewModel: ChooseCommunity.SearchCommunities.ViewModel) {
        guard case let .result(data) = viewModel.state else { return }

        self.tableViewDataSource.filteredViewModels = data
        self.chooseCommunityView.updateTableViewData(dataSource: self.tableViewDataSource)
    }
}

extension ChooseCommunityViewController: ChooseCommunityTableDataSourceDelegate {
    func tableDidSelect(community: LemmyModel.CommunityView) {
        onCommunitySelected?(community)
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableShowNotFound() {
        self.chooseCommunityView.hideNotFound()
    }
}

extension ChooseCommunityViewController: ChooseCommunityUIDelegate {
    func chooseView(_ chooseView: ChooseCommunityUI, didRequestSearch query: String) {
        self.viewModel.doSearchCommunities(request: .init(query: query))
    }
}

// MARK: - CreatePostScreenViewController: StyledNavigationControllerPresentable -
extension ChooseCommunityViewController: StyledNavigationControllerPresentable {
    var navigationBarAppearanceOnFirstPresentation: StyledNavigationController.NavigationBarAppearanceState {
        .pageSheetAppearance()
    }
}
