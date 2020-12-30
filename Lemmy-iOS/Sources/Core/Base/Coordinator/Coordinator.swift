//
//  Coordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/11/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController? { get set }
    
    func start()
}

extension Coordinator {
    func store(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func free(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}

class BaseCoordinator: NSObject, Coordinator {    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    
    var isCompleted: (() -> Void)?

    func start() {
        fatalError("Children should implement `start`.")
    }
}
