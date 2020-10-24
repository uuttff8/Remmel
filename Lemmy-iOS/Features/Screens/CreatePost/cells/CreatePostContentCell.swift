//
//  CreatePostContentCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 21.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CreatePostContentCell: UITableViewCell {
    
    lazy var titleTextView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 17)
        tv.textColor = UIColor.lightGray
        tv.placeholder = "Title"
        return tv
    }()
    
    lazy var bodyTextView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 17)
        tv.textColor = UIColor.lightGray
        tv.placeholder = "Body"
        return tv
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        [titleTextView, bodyTextView].forEach { (view) in
            contentView.addSubview(view)
        }
        
        
        titleTextView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(5)
            make.height.equalTo(200)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        bodyTextView.snp.makeConstraints { (make) in
            make.top.equalTo(titleTextView.snp.bottom).inset(5)
            make.height.equalTo(200)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(5)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

