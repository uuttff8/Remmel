//
//  CreatePostModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 20.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol CreatePostViewModelProtocol: AnyObject {
    func doCreatePostLoad(request: CreatePost.CreatePostLoad.Request)
    
    // ChooseCommunity
    func doChoosingCommunityPresentation(request: CreatePost.ChooseCommunityFormPresentation.Request)
    func doChoosingCommunityUpdate(request: CreatePost.ChooseCommunityFormUpdate.Request)
}

class CreatePostViewModel: CreatePostViewModelProtocol {
    
    weak var viewController: CreatePostScreenViewControllerProtocol?
    
    struct Data {
        let community: LemmyModel.CommunityView?
        let title: String?
        let body: String?
        let url: String?
        let nsfwOption: Bool
    }
    
    // MARK: - Properties
    
    private var createPostData: Data {
        .init(
            community: self.selectedCommunity,
            title: self.communityTitle,
            body: self.communityBody,
            url: self.communityUrl,
            nsfwOption: self.nsfwOption
        )
    }
    
    // nil mean it is not selected
    private var selectedCommunity: LemmyModel.CommunityView?
    private var communityTitle: String?
    private var communityBody: String?
    private var communityUrl: String?
    private var nsfwOption: Bool = false
    
    //    var communitiesLoaded: (([LemmyModel.CommunityView]) -> Void)?
    //
    //    var communitySelectedCompletion: ((LemmyModel.CommunityView) -> Void)?
    //
    //    var communitySelected: LemmyModel.CommunityView? {
    //        didSet {
    //            guard let community = communitySelected else { return }
    //
    //            communitySelectedCompletion?(community)
    //        }
    //    }
    //
    //    var communitiesData: [LemmyModel.CommunityView] = [] {
    //        didSet {
    //            communitiesLoaded?(communitiesData)
    //        }
    //    }
    //    var filteredCommunitiesData: [LemmyModel.CommunityView] = [] {
    //        didSet {
    //            communitiesLoaded?(filteredCommunitiesData)
    //        }
    //    }
    
    // MARK: - Initializer
    init() { }
    
    func doCreatePostLoad(request: CreatePost.CreatePostLoad.Request) {
        self.viewController?.displayCreatingPost(viewModel: .init(viewModel: self.createPostData))
    }
    
    func doChoosingCommunityPresentation(request: CreatePost.ChooseCommunityFormPresentation.Request) {
        
    }
    
    func doChoosingCommunityUpdate(request: CreatePost.ChooseCommunityFormUpdate.Request) {
        
    }
    
    // MARK: - Api Request
    func loadCommunities() {
        let parameters = LemmyModel.Community.ListCommunitiesRequest(sort: LemmySortType.topAll,
                                                                     limit: 100,
                                                                     page: nil,
                                                                     auth: LemmyShareData.shared.jwtToken)
        
        ApiManager.requests.listCommunities(
            parameters: parameters
        ) { (res: Result<LemmyModel.Community.ListCommunitiesResponse, LemmyGenericError>) in
            
            switch res {
            case let .success(data):
                //                self.communitiesData = data.communities
                //                self.communitiesLoaded?(data.communities)
                break
            case let .failure(why):
                print(why)
            }
        }
    }
    
    func searchCommunities(query: String) {
        let params = LemmyModel.Search.SearchRequest(query: query,
                                                     type: .all,
                                                     communityId: nil,
                                                     communityName: nil,
                                                     sort: .topAll,
                                                     page: 1,
                                                     limit: 100,
                                                     auth: LemmyShareData.shared.jwtToken)
        
        ApiManager.requests.search(
            parameters: params
        ) { (res: Result<LemmyModel.Search.SearchResponse, LemmyGenericError>) in
            
            switch res {
            case let .success(data):
                //                self.filteredCommunitiesData = data.communities
                break
            case let .failure(why):
                print(why)
            }
        }
        
    }
    
    func createPost(
        data: Data,
        completion: @escaping ((Result<LemmyModel.PostView, LemmyGenericError>) -> Void)
    ) {
        guard let jwtToken = LemmyShareData.shared.jwtToken
        else {
            completion(.failure(.string("Not logined")))
            return
        }
        
//        let params = LemmyModel.Post.CreatePostRequest(name: data.title,
//                                                       url: data.url,
//                                                       body: data.body,
//                                                       nsfw: data.nsfwOption,
//                                                       communityId: data.community.id,
//                                                       auth: jwtToken)
//
//        ApiManager.requests.createPost(
//            parameters: params
//        ) { (res: Result<LemmyModel.Post.CreatePostResponse, LemmyGenericError>) in
//            switch res {
//            case .success(let data):
//                completion(.success(data.post))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
    }
}
