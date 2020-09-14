//
//  CommunitiesModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/14/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CommunitiesModel: NSObject {
    
    var dataLoaded: (() -> Void)?
    
    var communitiesDataSource: Array<LemmyApiStructs.CommunityView>?
    
    func loadCommunities() {
        let parameters = LemmyApiStructs.Community.ListCommunitiesRequest(sort: "TopAll",
                                                                          limit: 100,
                                                                          page: 1,
                                                                          auth: nil)
        
        ApiManager.shared.requestsManager
            .listCommunities(parameters: parameters)
            { (res: Result<LemmyApiStructs.Community.ListCommunitiesResponse, Error>) in
                
                switch res {
                case .success(let data):
                    self.communitiesDataSource = data.communities
                    DispatchQueue.main.async {
                        self.dataLoaded?()
                    }
                case .failure(let error):
                    print(error)
                }
        }
    }
}


extension CommunitiesModel: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let communities = communitiesDataSource else { return 0 }
        return communities.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let communities = communitiesDataSource else {
            return UITableViewCell()
        }
        
        let cell = CommunityPreviewTableCell()
        cell.bind(with: communities[indexPath.row])
        return cell
    }
}
