//
//  CommentsFrontPageViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CommentsFrontPageViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    weak var coordinator: FrontPageCoordinator?
    
    let model = CommentsFrontPageModel()
    
    let tableView = LemmyUITableView(style: .plain)
    private lazy var dataSource = makeDataSource()
    private var snapshot = NSDiffableDataSourceSnapshot<Section, LemmyApiStructs.CommentView>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = model
                
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        model.loadComments()
        
        model.dataLoaded = { [self] newComments in
            addFirstRows(with: newComments)
        }
        
        model.newDataLoaded = { [self] newComments in
            addRows(with: newComments)
        }
    }
    
    func addRows(with list: Array<LemmyApiStructs.CommentView>, animate: Bool = true) {
        snapshot.insertItems(list, afterItem: model.commentsDataSource.last!)
        self.model.commentsDataSource.append(contentsOf: list)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func addFirstRows(with list: Array<LemmyApiStructs.CommentView>, animate: Bool = true) {
        snapshot.appendSections([.main])
        snapshot.appendItems(list)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    
    private func makeDataSource() -> UITableViewDiffableDataSource<Section, LemmyApiStructs.CommentView> {
        return UITableViewDiffableDataSource<Section, LemmyApiStructs.CommentView>(
            tableView: tableView,
            cellProvider: { (tableView, indexPath, postView) -> UITableViewCell? in
                let cell = CommentContentTableCell()
                cell.commentContentView.delegate = self.model
                cell.bind(with: self.model.commentsDataSource[indexPath.row])
                
                return cell
        })
    }
}
