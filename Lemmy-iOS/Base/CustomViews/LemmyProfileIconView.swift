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
        return btn
    }()
    
    init() {
        super.init(frame: .zero)
        
        self.addSubview(imageButton)
        imageButton.snp.makeConstraints { (make) in
            make.top.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(30)
        }
        self.backgroundColor = UIColor.red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
