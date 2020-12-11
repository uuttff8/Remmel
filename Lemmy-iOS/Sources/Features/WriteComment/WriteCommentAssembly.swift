//
//  WriteCommentAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 09.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class WriteCommentAssembly: Assembly {
    
    private let parentId: Int?
    private let postId: Int
    
    init(parentId: Int?, postId: Int) {
        self.parentId = parentId
        self.postId = postId
    }
    
    func makeModule() -> WriteCommentViewController {
        let viewModel = WriteCommentViewModel(parentId: parentId, postId: postId)
        let vc = WriteCommentViewController(viewModel: viewModel)
        viewModel.viewController = vc
        
        return vc
    }
}
