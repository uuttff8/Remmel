//
//  InstancesTableDataSource.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 19.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class InstancesTableDataSource: NSObject {
    var viewModels: [Instance]
    
    init(viewModels: [Instance] = []) {
        self.viewModels = viewModels
        super.init()
    }
}

extension InstancesTableDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.accessoryType = .detailDisclosureButton
        
        let instance = viewModels[indexPath.row]
        cell.textLabel?.text = instance.label
        
        return cell
    }
}
