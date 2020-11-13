//
//  FrontPageSearchView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 12.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

extension FrontPageSearchView {
    struct Appearance {
        let fadeAnimationDuratation: TimeInterval = 0.3
    }
}

class FrontPageSearchView: UIView {
    let appearance: Appearance
    
    init(appearance: Appearance = Appearance()) {
        self.appearance = appearance
        super.init(frame: .zero)
        
        self.backgroundColor = .systemBackground
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public API
    func fadeInIfNeeded() {
        guard self.alpha == 0 else { return }
        
        UIView.animate(withDuration: appearance.fadeAnimationDuratation, animations: {
            self.alpha = 1.0
        })
    }
    
    func fadeOutIfNeeded() {
        guard self.alpha == 1 else { return }
        
        UIView.animate(withDuration: appearance.fadeAnimationDuratation, animations: {
            self.alpha = 0.0
        })
    }
}
