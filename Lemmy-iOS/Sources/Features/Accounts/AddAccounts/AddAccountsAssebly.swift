//
//  AddAccountsAssebly.swift
//  Lemmy-iOS
//
//  Created by Komolbek Ibragimov on 25/12/2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class AddAccountsAssembly: Assembly {
    func makeModule() -> AddAccountsViewController {
        let viewModel = AddAccountsViewModel()
        let vc = AddAccountsViewController(viewModel: viewModel)
        return vc
    }
}
