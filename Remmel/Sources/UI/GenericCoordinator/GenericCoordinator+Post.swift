//
//  GenericCoordinator+Post.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 08/10/2022.
//  Copyright © 2022 Anton Kuzmin. All rights reserved.
//

import UIKit

extension GenericCoordinator {
    func goToPostScreen(postId: Int) {
        goToPostScreenWrapper(post: nil, postId: postId)
    }
    
    func goToPostScreen(post: LMModels.Views.PostView) {
        goToPostScreenWrapper(post: post, postId: post.id)
    }
    
    private func goToPostScreenWrapper(post: LMModels.Views.PostView?, postId: Int) {
        let coordinator = PostScreenCoordinator(
            router: Router(navigationController: navigationController),
            postId: postId,
            postInfo: post
        )
        
        store(coordinator: coordinator)
        coordinator.start()
        
        router?.push(
            coordinator.rootViewController,
            isAnimated: true,
            onNavigateBack: { [weak self] in
                self?.free(coordinator: coordinator)
            }
        )
    }
    
    func goToPostAndScroll(to comment: LMModels.Views.CommentView) {
        let coordinator = PostScreenCoordinator(
            router: Router(navigationController: navigationController),
            postId: comment.post.id,
            postInfo: nil,
            scrollToComment: comment
        )
        
        store(coordinator: coordinator)
        coordinator.start()
        
        coordinator.router?.push(
            coordinator.rootViewController,
            isAnimated: true,
            onNavigateBack: { [weak self] in
                self?.free(coordinator: coordinator)
            }
        )
    }
    
    func goToCreatePost(predefinedCommunity: LMModels.Views.CommunityView? = nil) {
        let createPostCoord = CreatePostCoordinator(
            navigationController: StyledNavigationController(),
            predefinedCommunity: predefinedCommunity
        )
        
        guard let navController = createPostCoord.navigationController else {
            return
        }
        
        store(coordinator: createPostCoord)
        createPostCoord.start()

        rootViewController.present(navController, animated: true)
    }
    
    func goToEditPost(post: LMModels.Source.Post, completion: (() -> Void)? = nil) {
        let assembly = EditPostAssembly(postSource: post)
        let module = assembly.makeModule()
        
        module.completionHandler = completion
        let navController = UINavigationController(rootViewController: module)
        
        rootViewController.present(navController, animated: true)
    }
}
