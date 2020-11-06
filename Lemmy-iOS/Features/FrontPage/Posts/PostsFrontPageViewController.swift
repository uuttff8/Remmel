//
//  PostsFrontPageViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class PostsFrontPageViewController: UIViewController {
    
    enum Section: Hashable, CaseIterable {
        case posts
    }
    
    weak var coordinator: FrontPageCoordinator?
    
    let model = PostsFrontPageModel()
    
    let tableView = LemmyTableView(style: .plain)
    private lazy var dataSource = makeDataSource()
    private var snapshot = NSDiffableDataSourceSnapshot<Section, LemmyModel.PostView>()
    
    let pickerView = LemmySortListingPickersView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.registerClass(PostContentTableCell.self)
        self.view.addSubview(tableView)
        setupTableHeaderView()
        
        model.loadPosts()
        
        model.dataLoaded = { [self] newPosts in
            addFirstRows(with: newPosts)
        }
        
        model.newDataLoaded = { [self] newPosts in
            addRows(with: newPosts)
        }
        
        model.goToPostScreen = { [self] (post: LemmyModel.PostView) in
            coordinator?.goToPostScreen(post: post)
        }
        
        model.goToCommunityScreen = { [self] (fromPost) in
            coordinator?.goToCommunityScreen(communityId: fromPost.communityId)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func addRows(with list: [LemmyModel.PostView], animate: Bool = true) {
        snapshot.insertItems(list, afterItem: model.postsDataSource.last!)
        self.model.postsDataSource.append(contentsOf: list)
        DispatchQueue.main.async { [self] in
            dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
    func addFirstRows(with list: [LemmyModel.PostView], animate: Bool = true) {
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(list, toSection: .posts)
        DispatchQueue.main.async { [self] in
            dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
    fileprivate func setupTableHeaderView() {
        tableView.tableHeaderView = pickerView
        
        pickerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width)
        }
        
        pickerView.sortTypeView.addTap {
            self.present(self.pickerView.sortTypeView.configuredAlert, animated: true)
        }
        
        pickerView.listingTypeView.addTap {
            self.present(self.pickerView.listingTypeView.configuredAlert, animated: true)
        }
        
        pickerView.listingTypeView.newCasePicked = { [self] pickedValue in
            self.model.currentFeedType = pickedValue.toInitiallyListing
            
            snapshot.deleteAllItems()
            DispatchQueue.main.async {
                dataSource.apply(snapshot)
            }
            
            model.loadPosts()
        }
        
        pickerView.sortTypeView.newCasePicked = { [self] pickedValue in
            self.model.currentSortType = pickedValue
            
            snapshot.deleteAllItems()
            DispatchQueue.main.async {
                dataSource.apply(snapshot)
            }

            model.loadPosts()
        }
    }
    
    private func makeDataSource() -> UITableViewDiffableDataSource<Section, LemmyModel.PostView> {
        return UITableViewDiffableDataSource<Section, LemmyModel.PostView>(
            tableView: tableView,
            cellProvider: { (tableView, indexPath, _) -> UITableViewCell? in
                
                    let cell = tableView.cell(forClass: PostContentTableCell.self)
                    cell.postContentView.delegate = self.model
                    cell.bind(with: self.model.postsDataSource[indexPath.row], config: .default)
                    return cell
            })
    }
}

extension PostsFrontPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleDidSelectForPosts(indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let indexPathRow = indexPath.row
        let bottomItems = self.model.postsDataSource.count - 5

        if indexPathRow >= bottomItems {
            guard !model.isFetchingNewContent else { return }

            model.isFetchingNewContent = true
            model.currentPage += 1
            model.loadMorePosts {
                self.model.isFetchingNewContent = false
            }
        }
    }

    private func handleDidSelectForPosts(indexPath: IndexPath) {
        let post = model.postsDataSource[indexPath.row]
        coordinator?.goToPostScreen(post: post)
    }
}
