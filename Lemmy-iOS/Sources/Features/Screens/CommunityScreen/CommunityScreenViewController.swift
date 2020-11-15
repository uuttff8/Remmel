//
//  CommunityScreen.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 01.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

protocol CommunityScreenViewControllerProtocol: AnyObject {
    func displayCommunityHeader(viewModel: CommunityScreen.CommunityHeaderLoad.ViewModel)
    func displayPosts(viewModel: CommunityScreen.CommunityPostsLoad.ViewModel)
}

class CommunityScreenViewController: UIViewController {
    weak var coordinator: FrontPageCoordinator?
    
    private let viewModel: CommunityScreenViewModelProtocol
    private let tableDataSource = CommunityScreenTableDataSource()

    lazy var communityView = self.view as! CommunityScreenViewController.View
    
    private var state: CommunityScreen.ViewControllerState
    
    init(
        viewModel: CommunityScreenViewModelProtocol,
        state: CommunityScreen.ViewControllerState = .loading
    ) {
        self.viewModel = viewModel
        self.state = state
        super.init(nibName: nil, bundle: nil)
    }    
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = CommunityScreenViewController.View()
        view.delegate = self
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.doCommunityFetch()
        viewModel.doPostsFetch(request: .init(contentType: communityView.contentType))
        self.updateState(newState: state)
//        Publishers.Zip(model.$communitySubject, model.$postsSubject)
//            .filter({ $0.0 != nil })
//            .receive(on: RunLoop.main)
//            .sink { [self] (community, posts)  in
//                tableView.reloadSections(IndexSet(integer: Model.Section.posts.rawValue),
//                                         with: .automatic)
//                
//                if let community = community {
//                    tableView.reloadSections(IndexSet(integer: Model.Section.header.rawValue),
//                                             with: .automatic)
//                    self.updateUIOnData(community: community)
//                }
//                
//            }.store(in: &cancellable)
//        
//        model.$contentTypeSubject
//            .receive(on: RunLoop.main)
//            .sink(receiveValue: { _ in
//                self.model.asyncLoadPosts(id: self.model.communityId)
//            }).store(in: &cancellable)
        
//        model.newDataLoaded = { [self] newPosts in
//            guard !model.postsSubject.isEmpty else { return }
//
//            let startIndex = model.postsSubject.count - newPosts.count
//            let endIndex = startIndex + newPosts.count
//
//            let newIndexpaths =
//                Array(startIndex ..< endIndex)
//                .map { (index) in
//                    IndexPath(row: index, section: CommunityScreenModel.Section.posts.rawValue)
//                }
//
//            tableView.performBatchUpdates {
//                tableView.insertRows(at: newIndexpaths, with: .automatic)
//            }
//        }
        
//        model.goToPostScreen = { [self] (post) in
//            coordinator?.goToPostScreen(post: post)
//        }
//
    }
    
    private func updateState(newState: CommunityScreen.ViewControllerState) {
        defer {
            self.state = newState
        }

        if case .loading = newState {
            self.communityView.showLoadingView()
            return
        }

        if case .loading = self.state {
            self.communityView.hideLoadingView()
        }

        if case .result = newState {
            self.communityView.updateTableViewData(dataSource: self.tableDataSource)
        }
    }
}

extension CommunityScreenViewController: CommunityScreenViewControllerProtocol {
    func displayCommunityHeader(viewModel: CommunityScreen.CommunityHeaderLoad.ViewModel) {
        self.communityView.communityHeaderViewData = viewModel.data.community
        self.title = viewModel.data.community.name
    }
    
    func displayPosts(viewModel: CommunityScreen.CommunityPostsLoad.ViewModel) {
        guard case let .result(data) = viewModel.state else { return }
        self.tableDataSource.viewModels = data
        self.updateState(newState: viewModel.state)
    }
}

extension CommunityScreenViewController: CommunityScreenViewDelegate {
    func communityViewDidPickerTapped(_ communityView: View, toVc: UIViewController) {
        self.present(toVc, animated: true)
    }
    
    func communityViewDidReadMoreTapped(_ communityView: View, toVc: MarkdownParsedViewController) {
        self.present(toVc, animated: true)
    }
}
