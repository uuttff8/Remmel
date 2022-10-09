//
//  WriteCommentParrentPreviewCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 12.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class WriteCommentParrentPreviewCell: UITableViewCell {
    
}

final class WriteCommentParrentPreviewView: UIView {
    
    struct ViewData {
        let iconStringUrl: String
    }
    
    private let iconSize = CGSize(width: 32, height: 32)
    
    private let userImageView = UIImageView()
    
    init() {
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with data: ViewData) {
        
    }
}

extension WriteCommentParrentPreviewView: ProgrammaticallyViewProtocol {
    func setupView() {
    }
    
    func addSubviews() {
    }
    
    func makeConstraints() {
    }
}
