//
//  GenericCoordinator+Community.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 08/10/2022.
//  Copyright © 2022 Anton Kuzmin. All rights reserved.
//

extension GenericCoordinator {
    func goToCommunityScreen(communityId: Int? = nil, communityName: String? = nil) {
        let coordinator = CommunityScreenCoordinator(
            router: Router(navigationController: navigationController),
            communityId: communityId,
            communityName: communityName
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
