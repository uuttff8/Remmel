//
//  CommunityScreen.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 01.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CommunityScreenViewController: UIViewController {
    
    let model = CommunityScreenModel()
    let customView = CommunityScreenUI()
    
    override func loadView() {
        self.view = customView
    }
    
    override func viewDidLoad() {
        
    }
}
