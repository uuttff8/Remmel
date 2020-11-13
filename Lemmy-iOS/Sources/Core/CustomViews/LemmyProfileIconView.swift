//
//  LemmyProfileIconView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/26/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class LemmyProfileIconView: UIView {
    
    let imageButton = ResizableButton().then {
        $0.setImage(UIImage(systemName: "person"), for: .normal)
    }

    init() {
        super.init(frame: .zero)

        self.addSubview(imageButton)
        
        imageButton.imageView?.setRadius(radius: 4)
        
        imageButton.imageView?.snp.makeConstraints {
            $0.size.equalTo(34)
        }
        
        imageButton.snp.makeConstraints { (make) in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
