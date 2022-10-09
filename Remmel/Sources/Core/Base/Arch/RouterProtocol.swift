//
//  RouterProtocol.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 30.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

typealias NavigationBackClosure = (() -> Void)

protocol RouterProtocol: AnyObject {
    
    var navigationController: UINavigationController? { get set }
    var viewController: UIViewController? { get set }
    
    func push(_ drawable: Drawable, isAnimated: Bool, onNavigateBack: NavigationBackClosure?)
    func setRoot(_ drawable: Drawable, isAnimated: Bool)
    func pop(_ isAnimated: Bool)
    func popToRoot(_ isAnimated: Bool)
    func present(_ module: Drawable, animated: Bool)
}

class Router: NSObject, RouterProtocol {

    var navigationController: UINavigationController?
    weak var viewController: UIViewController?
    private var closures: [String: NavigationBackClosure] = [:]

    init(navigationController: UINavigationController?) {
        super.init()
        self.navigationController = navigationController
        
        if let navControl = navigationController as? StyledNavigationController {
            navControl.addDelegate(self)
        } else {
            self.navigationController?.delegate = self
        }
    }

    func push(_ drawable: Drawable, isAnimated: Bool, onNavigateBack closure: NavigationBackClosure?) {
        guard let viewController = drawable.viewController else {
            return
        }

        if let closure = closure {
            closures.updateValue(closure, forKey: viewController.description)
        }
        navigationController?.pushViewController(viewController, animated: isAnimated)
    }
    
    func setRoot(_ drawable: Drawable, isAnimated: Bool) {
        guard let viewController = drawable.viewController else {
            return
        }
        
        navigationController?.setViewControllers([viewController], animated: isAnimated)
    }
    
    func pop(_ isAnimated: Bool) {
        navigationController?.popViewController(animated: isAnimated)
    }
    
    func popToRoot(_ isAnimated: Bool) {
        navigationController?.popToRootViewController(animated: isAnimated)
    }
    
    func present(_ module: Drawable, animated: Bool) {
        guard let drawViewController = module.viewController else {
            return
        }
        
        viewController?.present(drawViewController, animated: true)
    }

    private func executeClosure(_ viewController: UIViewController) {
        guard let closure = closures.removeValue(forKey: viewController.description) else {
            return
        }
        closure()
    }
}

extension Router: UINavigationControllerDelegate {

    func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {

        guard let previousController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(previousController) else {
                return
        }
        executeClosure(previousController)
    }
}
