//
//  SearchResultsViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 02.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol SearchResultsViewControllerProtocol: AnyObject {
    func displayPosts(viewModel: SearchResults.LoadPosts.ViewModel)
    func displayUsers(viewModel: SearchResults.LoadUsers.ViewModel)
    func displayCommunities(viewModel: SearchResults.LoadCommunities.ViewModel)
    func displayComments(viewModel: SearchResults.LoadComments.ViewModel)
}

class SearchResultsViewController: UIViewController {
    
    private let viewModel: SearchResultsViewModelProtocol
    
    init(
        viewModel: SearchResultsViewModelProtocol
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchResultsViewController: SearchResultsViewControllerProtocol {
    func displayPosts(viewModel: SearchResults.LoadPosts.ViewModel) { }
    
    func displayUsers(viewModel: SearchResults.LoadUsers.ViewModel) { }
     
    func displayCommunities(viewModel: SearchResults.LoadCommunities.ViewModel) { }
    
    func displayComments(viewModel: SearchResults.LoadComments.ViewModel) { }
}
