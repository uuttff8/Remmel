//
//  CommunityScreenViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 15.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

protocol CommunityScreenViewModelProtocol: AnyObject {
    func doCommunityFetch()
    func doPostsFetch(request: CommunityScreen.CommunityPostsLoad.Request)
    func doNextPostsFetch(request: CommunityScreen.NextCommunityPostsLoad.Request)
}

final class CommunityScreenViewModel: CommunityScreenViewModelProtocol {
    typealias PaginationState = (page: Int, hasNext: Bool)
    
    weak var viewController: CommunityScreenViewControllerProtocol?
    
    private var paginationState = PaginationState(page: 1, hasNext: true)
    
    private let communityId: LemmyModel.CommunityView.Id
    private let communityInfo: LemmyModel.CommunityView?
    
    private var cancellable = Set<AnyCancellable>()
    
    init(
        communityId: LemmyModel.CommunityView.Id,
        communityInfo: LemmyModel.CommunityView?
    ) {
        self.communityId = communityId
        self.communityInfo = communityInfo
    }
    
    func doCommunityFetch() {
        let parameters = LemmyModel.Community.GetCommunityRequest(id: communityId,
                                                                  name: nil,
                                                                  auth: LoginData.shared.jwtToken)
        
        ApiManager.requests.asyncGetCommunity(parameters: parameters)
            .receive(on: RunLoop.main)
            .sink { (error) in
                print(error)
            } receiveValue: { (response) in
                
                self.viewController?.displayCommunityHeader(
                    viewModel: .init(data: .init(community: response.community))
                )
            }.store(in: &cancellable)
    }
    
    func doPostsFetch(request: CommunityScreen.CommunityPostsLoad.Request) {
        let parameters = LemmyModel.Post.GetPostsRequest(type: .community,
                                                         sort: request.contentType,
                                                         page: paginationState.page,
                                                         limit: 50,
                                                         communityId: communityId,
                                                         communityName: nil,
                                                         auth: LoginData.shared.jwtToken)
        
        ApiManager.shared.requestsManager.asyncGetPosts(parameters: parameters)
            .receive(on: RunLoop.main)
            .sink { (error) in
                print(error)
            } receiveValue: { (response) in
                
                self.viewController?.displayPosts(
                    viewModel: .init(
                        state: .result(data: response.posts)
                    )
                )
            }.store(in: &cancellable)
    }
    
    func doNextPostsFetch(request: CommunityScreen.NextCommunityPostsLoad.Request) {
        self.paginationState.page += 1
        
        let parameters = LemmyModel.Post.GetPostsRequest(type: .community,
                                                         sort: request.contentType,
                                                         page: paginationState.page,
                                                         limit: 50,
                                                         communityId: communityId,
                                                         communityName: nil,
                                                         auth: LoginData.shared.jwtToken)
        
        ApiManager.requests.asyncGetPosts(parameters: parameters)
            .receive(on: RunLoop.main)
            .sink { (error) in
                print(error)
            } receiveValue: { (response) in
                
                self.viewController?.displayNextPosts(
                    viewModel: .init(
                        state: .result(data: response.posts)
                    )
                )
                
            }.store(in: &cancellable)

    }
}

enum CommunityScreen {
    enum CommunityPostsLoad {
        struct Request {
            let contentType: LemmySortType
        }
        
        struct ViewModel {
            var state: ViewControllerState
        }
    }
    
    enum NextCommunityPostsLoad {
        struct Request {
            let contentType: LemmySortType
        }
        
        struct ViewModel {
            let state: PaginationState
        }
    }
    
    enum CommunityHeaderLoad {
        struct ViewModel {
            let data: CommunityScreenViewController.View.HeaderViewData
        }
        
    }
    
    // MARK: - States
    
    enum ViewControllerState {
        case loading
        case result(data: [LemmyModel.PostView])
    }
    
    enum PaginationState {
        case result(data: [LemmyModel.PostView])
        case error(message: String)
    }
}
