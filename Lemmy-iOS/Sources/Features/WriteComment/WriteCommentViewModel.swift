//
//  WriteCommentViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 09.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol WriteCommentViewModelProtocol: AnyObject {
    func doWriteCommentFormLoad(request: WriteComment.FormLoad.Request)
}

class WriteCommentViewModel: WriteCommentViewModelProtocol {
    weak var viewController: WriteCommentViewControllerProtocol?
    
    func doWriteCommentFormLoad(request: WriteComment.FormLoad.Request) {
        
    }
}

enum WriteComment {
    enum FormLoad {
        struct Request { }
        
        struct ViewModel { }
    }
}
