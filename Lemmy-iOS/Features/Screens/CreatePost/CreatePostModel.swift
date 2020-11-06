//
//  CreatePostModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 20.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CreatePostScreenModel {

    struct CreatePostData {
        let communityId: Int
        let title: String
        let body: String?
        let url: String?
        let nsfwOption: Bool
    }

    // MARK: - Properties
    var communitiesLoaded: (([LemmyApiStructs.CommunityView]) -> Void)?

    var communitySelectedCompletion: ((LemmyApiStructs.CommunityView) -> Void)?

    var communitySelected: LemmyApiStructs.CommunityView? {
        didSet {
            guard let community = communitySelected else { return }

            communitySelectedCompletion?(community)
        }
    }

    var communitiesData: [LemmyApiStructs.CommunityView] = [] {
        didSet {
            communitiesLoaded?(communitiesData)
        }
    }
    var filteredCommunitiesData: [LemmyApiStructs.CommunityView] = [] {
        didSet {
            communitiesLoaded?(filteredCommunitiesData)
        }
    }

    // MARK: - Initializer
    init() { }

    // MARK: - Api Request
    func loadCommunities() {
        let parameters = LemmyApiStructs.Community.ListCommunitiesRequest(sort: LemmySortType.topAll,
                                                                          limit: 100,
                                                                          page: nil,
                                                                          auth: LemmyShareData.shared.jwtToken)

        ApiManager.requests.listCommunities(
            parameters: parameters
        ) { (res: Result<LemmyApiStructs.Community.ListCommunitiesResponse, LemmyGenericError>) in

            switch res {
            case let .success(data):
                self.communitiesData = data.communities
                self.communitiesLoaded?(data.communities)
            case let .failure(why):
                print(why)
            }
        }
    }

    func searchCommunities(query: String) {
        let params = LemmyApiStructs.Search.SearchRequest(query: query,
                                                          type: .all,
                                                          communityId: nil,
                                                          communityName: nil,
                                                          sort: .topAll,
                                                          page: 1,
                                                          limit: 100,
                                                          auth: LemmyShareData.shared.jwtToken)

        ApiManager.requests.search(
            parameters: params
        ) { (res: Result<LemmyApiStructs.Search.SearchResponse, LemmyGenericError>) in

            switch res {
            case let .success(data):
                self.filteredCommunitiesData = data.communities
            case let .failure(why):
                print(why)
            }
        }

    }

    func createPost(
        data: CreatePostData,
        completion: @escaping ((Result<LemmyApiStructs.PostView, LemmyGenericError>) -> Void)
    ) {
        guard let jwtToken = LemmyShareData.shared.jwtToken
        else {
            completion(.failure(.string("Not logined")))
            return
        }

        let params = LemmyApiStructs.Post.CreatePostRequest(name: data.title,
                                                            url: data.url,
                                                            body: data.body,
                                                            nsfw: data.nsfwOption,
                                                            communityId: data.communityId,
                                                            auth: jwtToken)

        ApiManager.requests.createPost(
            parameters: params
        ) { (res: Result<LemmyApiStructs.Post.CreatePostResponse, LemmyGenericError>) in
            switch res {
            case .success(let data):
                completion(.success(data.post))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
