//
//  CreatePostContentCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 21.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CreatePostUrlCell: UITableViewCell {
    
    lazy var selectImageButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "photo"), for: .normal)
        return btn
    }()
    
    lazy var urlTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "URL"
        return tf
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        [selectImageButton, urlTextField].forEach { (view) in
            contentView.addSubview(view)
        }
        
        urlTextField.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(5)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(selectImageButton.snp.leading)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().inset(5)
        }
        
        selectImageButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(5)
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(30)
            make.bottom.equalTo(urlTextField)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
