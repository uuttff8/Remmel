//
//  GenericCoordinator+Profile.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 08/10/2022.
//  Copyright © 2022 Anton Kuzmin. All rights reserved.
//

extension GenericCoordinator {
    func goToProfileScreen(userId: Int? = nil, username: String? = nil) {
        let coordinator = ProfileScreenCoordinator(
            router: Router(navigationController: navigationController),
            profileId: userId,
            profileUsername: username
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
}
