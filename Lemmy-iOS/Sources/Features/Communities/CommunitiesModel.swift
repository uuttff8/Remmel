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

    var communitiesDataSource: [LemmyModel.CommunityView]?

    func loadCommunities() {
        let parameters = LemmyModel.Community.ListCommunitiesRequest(sort: LemmySortType.topAll,
                                                                          limit: 100,
                                                                          page: 1,
                                                                          auth: LemmyShareData.shared.jwtToken)

        ApiManager.shared.requestsManager
            .listCommunities(
                parameters: parameters
            ) { (res: Result<LemmyModel.Community.ListCommunitiesResponse, LemmyGenericError>) in

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
        guard let communities = communitiesDataSource
            else { return UITableViewCell() }

        let cell = CommunityPreviewTableCell(community: communities[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension CommunitiesModel: CommunityPreviewTableCellDelegate {
    func follow(to community: LemmyModel.CommunityView) {
        print("followed to: \(community.name)")
    }
}
