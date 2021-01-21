//
//  LemmyNavSettingsView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 21.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

class LemmyNavSettingsView: UIView {
    
    let imageButton = ResizableButton().then {
        $0.setImage(UIImage(systemName: "gearshape"), for: .normal)
    }

    init() {
        super.init(frame: .zero)

        self.addSubview(imageButton)
        
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
