//
//  ViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/11/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ws = WSLemmy()
        
        let data = """
{"sort": "Hot","limit": 6}
"""
        
        ws.send(on: LemmyEndpoint.Community.listCommunities, data: Data(data.utf8))
        
    }
    
}

