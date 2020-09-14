//
//  CommunitiesCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/14/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CommunitiesCoordinator : Coordinator {
    var rootViewController: CommunitiesViewController
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.rootViewController = CommunitiesViewController()
        self.navigationController = navigationController
    }

    func start() {
        navigationController?.pushViewController(self.rootViewController, animated: true)
    }
}
