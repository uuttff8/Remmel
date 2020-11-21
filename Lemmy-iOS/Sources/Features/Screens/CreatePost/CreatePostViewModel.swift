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
        
    // MARK: - Initializer
    init() { }
    
    func doCreatePostLoad(request: CreatePost.CreatePostLoad.Request) {
        self.viewController?.displayCreatingPost(viewModel: .init(viewModel: self.createPostData))
    }
    
    func doChoosingCommunityPresentation(request: CreatePost.ChooseCommunityFormPresentation.Request) {
        
    }
    
    func doChoosingCommunityUpdate(request: CreatePost.ChooseCommunityFormUpdate.Request) {
        self.selectedCommunity = request.community
    }
    
    // MARK: - Api Request
    func createPost(
        data: Data,
        completion: @escaping ((Result<LemmyModel.PostView, LemmyGenericError>) -> Void)
    ) {
        // TODO handle creating post
    }
}
