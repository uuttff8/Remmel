//
//  SearchResultsAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 03.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMModels
import RMServices

class SearchResultsAssembly: Assembly {
    private let searchQuery: String
    private let searchType: RMModels.Others.SearchType
    
    init(searchQuery: String, type: RMModels.Others.SearchType) {
        self.searchQuery = searchQuery
        self.searchType = type
    }
    
    func makeModule() -> SearchResultsViewController {
        let userAccountService = UserAccountService()
        
        let viewModel = SearchResultsViewModel(
            searchQuery: searchQuery,
            searchType: searchType,
            userAccountService: userAccountService,
            contentScoreService: ContentScoreService(
                userAccountService: UserAccountService()
            )
        )
        let vc = SearchResultsViewController(
            viewModel: viewModel,
            showMoreHandler: ShowMoreHandlerServiceImp(),
            followService: CommunityFollowService(userAccountService: userAccountService)
        )
        viewModel.viewController = vc
        
        return vc
    }
}
