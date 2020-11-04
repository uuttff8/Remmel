//
//  PostsFrontPageViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class PostsFrontPageViewController: UIViewController {
    enum Section {
        case main
    }

    weak var coordinator: FrontPageCoordinator?

    let model = PostsFrontPageModel()

    let tableView = LemmyTableView(style: .plain)
    private lazy var dataSource = makeDataSource()
    private var snapshot = NSDiffableDataSourceSnapshot<Section, LemmyApiStructs.PostView>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = model

        tableView.registerClass(PostContentTableCell.self)

        self.view.addSubview(tableView)

        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        model.loadPosts()

        model.dataLoaded = { [self] newPosts in
            addFirstRows(with: newPosts)
        }

        model.newDataLoaded = { [self] newPosts in
            addRows(with: newPosts)
        }

        model.goToPostScreen = { [self] (post: LemmyApiStructs.PostView) in
            coordinator?.goToPostScreen(post: post)
        }
        
        model.goToCommunityScreen = { [self] (fromPost) in
            coordinator?.goToCommunityScreen(communityId: fromPost.communityId)
        }
    }

    func addRows(with list: [LemmyApiStructs.PostView], animate: Bool = true) {
        snapshot.insertItems(list, afterItem: model.postsDataSource.last!)
        self.model.postsDataSource.append(contentsOf: list)
        DispatchQueue.main.async { [self] in
            dataSource.apply(snapshot, animatingDifferences: false)
        }
    }

    func addFirstRows(with list: [LemmyApiStructs.PostView], animate: Bool = true) {
        snapshot.appendSections([.main])
        snapshot.appendItems(list)
        DispatchQueue.main.async { [self] in
            dataSource.apply(snapshot, animatingDifferences: false)
        }
    }

    private func makeDataSource() -> UITableViewDiffableDataSource<Section, LemmyApiStructs.PostView> {
        return UITableViewDiffableDataSource<Section, LemmyApiStructs.PostView>(
            tableView: tableView,
            cellProvider: { (tableView, indexPath, _) -> UITableViewCell? in

                let cell = tableView.cell(forClass: PostContentTableCell.self)
                cell.postContentView.delegate = self.model
                cell.bind(with: self.model.postsDataSource[indexPath.row], config: .post)

                return cell
        })
    }
}
