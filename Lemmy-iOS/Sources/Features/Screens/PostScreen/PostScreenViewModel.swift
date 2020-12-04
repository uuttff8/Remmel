//
//  PostScreenModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/2/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

protocol PostScreenViewModelProtocol: AnyObject {
    func doPostFetch()
    func doPostLike(voteButton: VoteButton, for newVote: LemmyVoteType, post: LemmyModel.PostView) // refactor
}

class PostScreenViewModel: PostScreenViewModelProtocol {
    weak var viewController: PostScreenViewControllerProtocol?
    
    private let contentScoreService: ContentScoreServiceProtocol
    
    private var cancellable = Set<AnyCancellable>()
    
    let postInfo: LemmyModel.PostView?
    let postId: Int
    
    init(
        postId: Int,
        postInfo: LemmyModel.PostView?,
        contentScoreService: ContentScoreServiceProtocol
    ) {
        self.postInfo = postInfo
        self.postId = postId
        self.contentScoreService = contentScoreService
    }
    
    func doPostFetch() {
        let parameters = LemmyModel.Post.GetPostRequest(id: postId,
                                                        auth: LemmyShareData.shared.jwtToken)
        
        ApiManager.shared.requestsManager.asyncGetPost(parameters: parameters)
            .receive(on: RunLoop.main)
            .sink { (error) in
                print(error)
            } receiveValue: { (response) in
                self.viewController?.displayPost(
                    response: .init(
                        state: .result(
                            data: self.makeViewData(from: response)
                        )
                    )
                )
            }.store(in: &cancellable)
    }
    
    private func saveNewPost(_ post: LemmyModel.PostView) { }
    
    func doPostLike(voteButton: VoteButton, for newVote: LemmyVoteType, post: LemmyModel.PostView) {
        self.contentScoreService.votePost(
            voteButton: voteButton,
            for: newVote,
            post: post
        ) { (post) in
            self.saveNewPost(post)
        }
    }
    
    private func makeViewData(from data: LemmyModel.Post.GetPostResponse) -> PostScreenViewController.View.ViewData {
        let comments = CommentListingSort(comments: data.comments)
            .createCommentsTree()
        
        print(comments)
        
        return .init(post: data.post, comments: comments)
    }
}

enum PostScreen {
    
    enum PostLoad {
        
        struct Response {
            let postId: ViewControllerState
        }
        
        struct ViewModel {
            let state: ViewControllerState
        }
    }
    
    // States
    enum ViewControllerState {
        case loading
        case result(data: PostScreenViewController.View.ViewData)
    }
}
