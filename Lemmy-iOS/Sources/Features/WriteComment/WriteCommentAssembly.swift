//
//  WriteCommentAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 09.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class WriteCommentAssembly: Assembly {
    func makeModule() -> WriteCommentViewController {
        let viewModel = WriteCommentViewModel()
        let vc = WriteCommentViewController(viewModel: viewModel)
        viewModel.viewController = vc
        
        return vc
    }
}
