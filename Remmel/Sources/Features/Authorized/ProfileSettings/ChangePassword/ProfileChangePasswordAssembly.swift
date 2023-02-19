//
//  ProfileChangePasswordAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 01.05.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation
import RMNetworking

final class ProfileChangePasswordAssembly: Assembly {
    func makeModule() -> ProfileChangePasswordViewController {
        let vm = ProfileChangePasswordViewModel(wsClient: ApiManager.chainedWsCLient)
        let vc = ProfileChangePasswordViewController(viewModel: vm)
        vm.viewContoller = vc
        
        return vc
    }
}
