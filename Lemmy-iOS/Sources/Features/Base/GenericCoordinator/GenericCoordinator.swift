//
//  GenericCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 09.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import SafariServices

class GenericCoordinator<T: UIViewController>: BaseCoordinator, SFSafariViewControllerDelegate {
    var rootViewController: T! // implement it
    
    var router: RouterProtocol?
    
    private let userAccountService: UserAccountSerivceProtocol = UserAccountService()
    
    init(router: RouterProtocol?) {
        self.router = router
        super.init()
        
        navigationController = router?.navigationController
        router?.viewController = self.rootViewController
    }
    
    override func start() {
        fatalError("Override this")
    }
    
    func goToCommunityScreen(communityId: Int? = nil, communityName: String? = nil) {
        let coordinator = CommunityScreenCoordinator(
            router: Router(navigationController: navigationController),
            communityId: communityId,
            communityName: communityName
        )
        store(coordinator: coordinator)
        coordinator.start()
        router?.push(coordinator.rootViewController, isAnimated: true, onNavigateBack: {
            [weak self] in

            self?.free(coordinator: coordinator)
        })
    }
    
    func goToProfileScreen(userId: Int? = nil, username: String? = nil) {
        let coordinator = ProfileScreenCoordinator(
            router: Router(navigationController: navigationController),
            profileId: userId,
            profileUsername: username
        )
        store(coordinator: coordinator)
        coordinator.start()
        self.router?.push(coordinator.rootViewController, isAnimated: true, onNavigateBack: {
            [weak self] in

            self?.free(coordinator: coordinator)
        })
    }
    
    func goToBrowser(with url: URL, inApp: Bool = true) {
        // https://stackoverflow.com/a/35458932
        if ["http", "https"].contains(url.scheme?.lowercased() ?? "") && inApp {
            // Can open with SFSafariViewController
            let safariVc = SFSafariViewController(url: url)
            safariVc.delegate = self
            rootViewController.present(safariVc, animated: true, completion: nil)
        } else {
            // Scheme is not supported or no scheme is given, use openURL
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
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
        router?.push(coordinator.rootViewController, isAnimated: true, onNavigateBack: {
            [weak self] in

            self?.free(coordinator: coordinator)
        })
    }
        
    func goToWriteComment(
        postSource: LMModels.Source.Post,
        parrentComment: LMModels.Source.Comment?,
        completion: (() -> Void)? = nil
    ) {
        ContinueIfLogined(on: rootViewController, coordinator: self) {
            // TODO(uuttff8): Move this code to another component
            let haptic = UIImpactFeedbackGenerator(style: .light)
            haptic.prepare()
            haptic.impactOccurred()
            
            self.goToWriteMessageWrapper(
                action: .writeComment(parentComment: parrentComment, postSource: postSource),
                completion: completion
            )
        }
    }
    
    func goToPostAndScroll(to comment: LMModels.Views.CommentView) {
        let coordinator = PostScreenCoordinator(
            router: Router(navigationController: navigationController),
            postId: comment.post.id,
            postInfo: nil,
            scrollToComment: comment
        )
        self.store(coordinator: coordinator)
        coordinator.start()
        coordinator.router?.push(coordinator.rootViewController, isAnimated: true, onNavigateBack: {
            [weak self] in

            self?.free(coordinator: coordinator)
        })
    }
    
    func goToInstances() {
        LemmyShareData.shared.loginData.logout()
        
        if !userAccountService.isAuthorized {
            self.childCoordinators.removeAll()
            
            NotificationCenter.default.post(name: .didLogin, object: nil)
            
            let myCoordinator = InstancesCoordinator(router: Router(navigationController: StyledNavigationController()))
            myCoordinator.start()
            childCoordinators.append(myCoordinator)
            myCoordinator.router.setRoot(myCoordinator, isAnimated: true)
            
            guard let appWindow = UIApplication.shared.windows.first, let navController = myCoordinator.router.navigationController else {
                Logger.common.emergency("App must have only one `root` window")
                return
            }
            
            appWindow.replaceRootViewControllerWith(navController, animated: true)
        } else {
            Logger.common.emergency("At going to instances, we must logout user!")
            fatalError("Unexpexted error, must not be happen")
        }
    }
    
    func goToCreatePost(predefinedCommunity: LMModels.Views.CommunityView? = nil) {
        let createPostCoord = CreatePostCoordinator(
            navigationController: StyledNavigationController(),
            predefinedCommunity: predefinedCommunity
        )
        store(coordinator: createPostCoord)
        createPostCoord.start()

        guard let navController = createPostCoord.navigationController else {
            return
        }

        rootViewController.present(navController, animated: true)
    }
    
    func goToEditPost(post: LMModels.Source.Post, completion: (() -> Void)? = nil) {
        let assembly = EditPostAssembly(postSource: post)
        let module = assembly.makeModule()
        
        module.completionHandler = completion
        let navController = UINavigationController(rootViewController: module)
        
        rootViewController.present(navController, animated: true)
    }
    
    func goToEditComment(comment: LMModels.Source.Comment, completion: (() -> Void)? = nil) {
        goToWriteMessageWrapper(action: .edit(comment: comment), completion: completion)
    }
    
    func goToWriteMessage(recipientId: Int, completion: (() -> Void)? = nil) {
        goToWriteMessageWrapper(action: .replyToPrivateMessage(recipientId: recipientId), completion: completion)
    }
    
    private func goToWriteMessageWrapper(action: WriteMessageAssembly.Action, completion: (() -> Void)? = nil) {
        let assembly = WriteMessageAssembly(action: action)
        let module = assembly.makeModule()
        module.completionHandler = completion
        
        let navigationController = StyledNavigationController(rootViewController: module)
        navigationController.presentationController?.delegate = module
        
        rootViewController.present(navigationController, animated: true)
    }
    
    // MARK: - SFSafariViewControllerDelegate

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        rootViewController.dismiss(animated: true)
    }
}
