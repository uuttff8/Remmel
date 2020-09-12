//
//  FrontPageModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class FrontPageModel: NSObject {
    var postsLoaded: (() -> Void)?
    
    var postsDataSource: Array<LemmyApiStructs.PostView>?
    
    func loadPosts() {
        let parameters = LemmyApiStructs.Post.GetPostsRequest(type_: "All",
                                                              sort: "Active",
                                                              page: 1,
                                                              limit: 20,
                                                              communityId: nil,
                                                              communityName: nil,
                                                              auth: nil)
        
        ApiManager.shared.requestsManager.getPosts(
            parameters: parameters,
            completion: { (dec: Result<LemmyApiStructs.Post.GetPostsResponse, Error>) in
                switch dec {
                case .success(let posts):
                    self.postsDataSource = posts.posts
                    DispatchQueue.main.async {
                        self.postsLoaded?()
                    }
                case .failure(let error):
                    print(error)
                }
        })
    }
}


extension FrontPageModel: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return FrontPageCells.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = FrontPageCells.allCases[section]
        switch section {
        case .header:
            return 1
        case .content:
            guard let posts = postsDataSource else {
                return 0
            }
            return posts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = FrontPageCells.allCases[indexPath.section]
        
        switch section {
        case .header:
            return FrontPageHeaderCell()
        case .content:
            guard let posts = postsDataSource else {
                return UITableViewCell()
            }
            let postCell = PostContentTableCell()
            postCell.bind(with: posts[indexPath.row])
            return postCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = FrontPageCells.allCases[indexPath.section]
        
        switch section {
        case .content:
            tableView.deselectRow(at: indexPath, animated: true)
        case .header:
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}


private enum FrontPageCells: CaseIterable {
    case header
    case content
}
