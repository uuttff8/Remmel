//
//  AddInstanceAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 21.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

final class AddInstanceAssembly: Assembly {
    func makeModule() -> AddInstanceViewController {
        let viewModel = AddInstanceViewModel()
        let vc = AddInstanceViewController(viewModel: viewModel)
        viewModel.viewController = vc
        
        return vc
    }
}
