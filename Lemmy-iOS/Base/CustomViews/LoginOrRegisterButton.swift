//
//  LoginOrRegisterButton.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/28/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class LoginOrRegisterButton: UIButton {
    var handlerButton: (() -> ())? = nil
    
    private lazy var textLabel: LemmyLinkedClickableUILabel = {
        let lbl = LemmyLinkedClickableUILabel()
        
        lbl.setLinkedTextWithHandler(text: "You must log in or register to comment.",
                                     link: "(login or register)",
                                     handler: handlerButton!)
        
        
        return lbl
    }()
    
    init() {
        super.init(frame: .zero)
        
        self.handlerButton = {
            print("asdasdasd")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

