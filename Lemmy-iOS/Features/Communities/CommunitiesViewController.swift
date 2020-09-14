//
//  CommunitiesViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/14/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CommunitiesViewController: UIViewController {
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.systemBackground
        
        let parameters = LemmyApiStructs.Community.ListCommunitiesRequest(sort: "TopAll",
                                                                          limit: 100,
                                                                          page: 1,
                                                                          auth: nil)
        
        ApiManager.shared.requestsManager
            .listCommunities(parameters: parameters)
            { (res: Result<LemmyApiStructs.Community.ListCommunitiesResponse, Error>) in
                
                switch res {
                case .success(let data):
                    print(data)
                case .failure(let error):
                    print(error)
                }
        }
    }
}
