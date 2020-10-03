//
//  LemmyGreenOutlinePostEmbed.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/28/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class LemmyGreenOutlinePostEmbed: UIView {
    
    struct Data {
        let title: String?
        let description: String?
    }
    
    let viewData: Data
    
    private var descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        return lbl
    }()
    
    init(with data: LemmyGreenOutlinePostEmbed.Data) {
        self.viewData = data
        super.init(frame: .zero)
        bindData()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindData() {
        titleLabel.text = viewData.title
        descriptionLabel.text = viewData.description
        
        if viewData.title == nil {
            titleLabel.isHidden = true
            titleLabel.removeFromSuperview()
        }
        if viewData.description == nil {
            descriptionLabel.isHidden = true
            descriptionLabel.removeFromSuperview()
        }
        
        if viewData.description == nil && viewData.title == nil {
            self.isHidden = true
            self.removeFromSuperview()
        }
    }
    
    func setupUI() {
        guard let _ = viewData.title else { return }
        
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.systemGreen.cgColor
        self.backgroundColor = UIColor.lightGray
        
        self.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(10)
        }
        
        if let _ = viewData.description {
            self.addSubview(descriptionLabel)
            
            descriptionLabel.snp.makeConstraints { (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(10)
                make.leading.equalToSuperview().inset(10)
                make.trailing.equalToSuperview().inset(10)
                make.bottom.equalToSuperview().inset(10)
            }
        } else {
            titleLabel.snp.remakeConstraints { (make) in
                make.top.leading.bottom.trailing.equalToSuperview().inset(10)
            }
        }
    }
}
