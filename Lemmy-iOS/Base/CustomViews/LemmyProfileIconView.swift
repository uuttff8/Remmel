//
//  LemmyProfileIconView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/26/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class LemmyProfileIconView: UIView {
    let imageButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "person"), for: .normal)
        return btn
    }()
    
    init() {
        super.init(frame: .zero)
        
        self.addSubview(imageButton)
        
        imageButton.snp.makeConstraints { (make) in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
//        imageButton.imageView?.snp.makeConstraints({ (make) in
//            make.size.equalTo(30)
//        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
