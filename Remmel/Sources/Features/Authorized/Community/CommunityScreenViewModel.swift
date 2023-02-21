//
//  CommunityScreenViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 15.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine
import RMNetworking
import RMModels
import RMFoundation

protocol CommunityScreenViewModelProtocol: AnyObject {
    func doReceiveMessages()
    func doCommunityFetch()
    func doCommunityShowMore(request: CommunityScreen.CommunityShowMore.Request)
    func doPostsFetch(request: CommunityScreen.CommunityPostsLoad.Request)
    func doNextPostsFetch(request: CommunityScreen.NextCommunityPostsLoad.Request)
}

final class CommunityScreenViewModel: CommunityScreenViewModelProtocol {
    typealias PaginationState = (page: Int, hasNext: Bool)
    
    weak var viewController: CommunityScreenViewControllerProtocol?
    
    private weak var wsClient: WSClientProtocol?
    
    private var paginationState = 1
    
    private let communityId: RMModels.Views.CommunityView.ID?
    private let communityName: String?
    
    var loadedCommunity: RMModels.Views.CommunityView?
    
    private var cancellable = Set<AnyCancellable>()
    
    init(
        communityId: RMModels.Views.CommunityView.ID?,
        communityName: String?,
        wsClient: WSClientProtocol?
    ) {
        self.communityId = communityId
        self.communityName = communityName
        self.wsClient = wsClient
    }
    
    func doReceiveMessages() {
        wsClient?.onTextMessage.addObserver(self, completionHandler: { [weak self] operation, data in
            switch operation {
            case RMUserOperation.EditPost.rawValue,
                 RMUserOperation.DeletePost.rawValue,
                 RMUserOperation.RemovePost.rawValue,
                 RMUserOperation.LockPost.rawValue,
                 RMUserOperation.StickyPost.rawValue,
                 RMUserOperation.SavePost.rawValue:
                
                guard let newPost = self?.wsClient?.decodeWsType(
                    RMModels.Api.Post.PostResponse.self,
                    data: data
                ) else { return }
                
                DispatchQueue.main.async {
                    self?.viewController?.displayUpdatePost(viewModel: .init(postView: newPost.postView))
                }
            case RMUserOperation.CreatePostLike.rawValue:
                guard let newPost = self?.wsClient?.decodeWsType(
                    RMModels.Api.Post.PostResponse.self,
                    data: data
                ) else { return }
                
                DispatchQueue.main.async {
                    self?.viewController?.displayCreatePostLike(viewModel: .init(postView: newPost.postView))
                }
                
            case RMUserOperation.GetCommunity.rawValue:
                guard let newComm = self?.wsClient?.decodeWsType(
                    RMModels.Api.Community.CommunityResponse.self,
                    data: data
                ) else { return }
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.loadedCommunity = newComm.communityView
                    
                    self.viewController?.displayCommunityHeader(
                        viewModel: .init(data: .init(communityView: newComm.communityView))
                    )
                }

            default: break
            }
        })
    }
    
    func doCommunityFetch() {
        let parameters = RMModels.Api.Community.GetCommunity(id: self.communityId,
                                                             name: self.communityName,
                                                             auth: LoginData.shared.jwtToken)
        
        self.wsClient?.send(RMUserOperation.GetCommunity, parameters: parameters)
    }
    
    func doPostsFetch(request: CommunityScreen.CommunityPostsLoad.Request) {
        self.paginationState = 1
        
        let parameters = RMModels.Api.Post.GetPosts(type: .community,
                                                    sort: request.contentType,
                                                    page: self.paginationState,
                                                    limit: 50,
                                                    communityId: self.communityId,
                                                    communityName: self.communityName,
                                                    savedOnly: false,
                                                    auth: LoginData.shared.jwtToken)
        
        ApiManager.requests.asyncGetPosts(parameters: parameters)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                Logger.logCombineCompletion(completion)
            } receiveValue: { response in
                self.viewController?.displayPosts(
                    viewModel: .init(
                        state: .result(data: response.posts)
                    )
                )
            }.store(in: &cancellable)
    }
    
    func doNextPostsFetch(request: CommunityScreen.NextCommunityPostsLoad.Request) {
        self.paginationState += 1
        
        let parameters = RMModels.Api.Post.GetPosts(type: .community,
                                                    sort: request.contentType,
                                                    page: self.paginationState,
                                                    limit: 50,
                                                    communityId: self.communityId,
                                                    communityName: self.communityName,
                                                    savedOnly: false,
                                                    auth: LoginData.shared.jwtToken)
        
        ApiManager.requests.asyncGetPosts(parameters: parameters)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                Logger.logCombineCompletion(completion)
            } receiveValue: { response in
                
                self.viewController?.displayNextPosts(
                    viewModel: .init(
                        state: .result(data: response.posts)
                    )
                )
                
            }.store(in: &cancellable)
    }
    
    func doCommunityShowMore(request: CommunityScreen.CommunityShowMore.Request) {
        if let community = loadedCommunity {
            self.viewController?.displayCommunityShowMore(viewModel: .init(community: community))
        } else {
            debugPrint("Show More bar button in CommunityScreen called on nil community data")
        }
    }
}

enum CommunityScreen {
    enum CommunityPostsLoad {
        struct Request {
            let contentType: RMModels.Others.SortType
        }
        
        struct ViewModel {
            var state: ViewControllerState
        }
    }
    
    enum NextCommunityPostsLoad {
        struct Request {
            let contentType: RMModels.Others.SortType
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
    
    enum CommunityShowMore {
        struct Request { }
        struct ViewModel {
            let community: RMModels.Views.CommunityView
        }
    }
    
    enum UpdatePost {
        struct ViewModel {
            let postView: RMModels.Views.PostView
        }
    }
    
    enum CreateCommentLike {
        struct ViewModel {
            let postView: RMModels.Views.PostView
        }
    }
    
    // MARK: - States
    
    enum ViewControllerState {
        case loading
        case result(data: [RMModels.Views.PostView])
    }
    
    enum PaginationState {
        case result(data: [RMModels.Views.PostView])
        case error(message: String)
    }
}
