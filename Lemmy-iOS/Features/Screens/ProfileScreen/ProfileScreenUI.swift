//
//  ProfileScreenUI.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 07.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class LemmyUserProfileView: UIView {
    
}

extension ProfileScreenViewController {
    class View: UIView {
        
        let tableView = LemmyTableView(style: .plain, separator: false)
    }
}

extension ProfileScreenViewController.View: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
