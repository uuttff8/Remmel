//
//  FrontPageSearchView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 12.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMModels

protocol FrontPageSearchViewDelegate: AnyObject {
    func searchView(_ searchView: FrontPageSearchView, searchWith query: String, type: RMModels.Others.SearchType)
}

extension FrontPageSearchView {
    struct Appearance {
        let searchTypeConfig: [RMModels.Others.SearchType] = [.comments, .posts, .communities, .users]
        let fadeAnimationDuratation: TimeInterval = 0.3
        let alphaAtInit: CGFloat = 0.0
        
        let tableInset = UIEdgeInsets(top: UIScreen.main.bounds.height / 10,
                                      left: 0,
                                      bottom: 0,
                                      right: 0)
    }
}

class FrontPageSearchView: UIView {
    weak var delegate: FrontPageSearchViewDelegate?
    
    let appearance: Appearance
    
    private var searchText: String = ""
    
    private lazy var searchHeaderLabel = SearchTableHeaderLabel()
    
    private lazy var tableView = LemmyTableView(style: .grouped, separator: true).then {
        $0.registerClass(FrontPageSearchSubjectTableCell.self)
        $0.delegate = self
        $0.dataSource = self
        $0.contentInset = self.appearance.tableInset
    }
    
    init(appearance: Appearance = Appearance()) {
        self.appearance = appearance
        super.init(frame: .zero)
        
        setupView()
        addSubviews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public API
    // warning: function is called many many times when typing
    func configure(with searchText: String) {
        self.searchText = searchText
        tableView.reloadData()
    }
    
    func fadeInIfNeeded() {
        guard alpha == 0 else {
            return
        }
        
        UIView.animate(withDuration: appearance.fadeAnimationDuratation, animations: {
            self.alpha = 1.0
        })
    }
    
    func fadeOutIfNeeded() {
        guard alpha == 1 else {
            return
        }
        
        UIView.animate(withDuration: appearance.fadeAnimationDuratation, animations: {
            self.alpha = 0.0
        })
    }
}

extension FrontPageSearchView: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.appearance.searchTypeConfig.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FrontPageSearchSubjectTableCell
        
        switch self.appearance.searchTypeConfig[indexPath.row] {
        case .comments:
            cell = tableView.cell(forRowAt: indexPath)
            cell.configure(with: searchText, type: .comments)
            return cell
        case .communities:
            cell = tableView.cell(forRowAt: indexPath)
            cell.configure(with: searchText, type: .communities)
            return cell
        case .posts:
            cell = tableView.cell(forRowAt: indexPath)
            cell.configure(with: searchText, type: .posts)
            return cell
        case .users:
            cell = tableView.cell(forRowAt: indexPath)
            cell.configure(with: searchText, type: .users)
            return cell
        default:
            fatalError("This sort type should never call at this time")
        }
    }
    
    // MARK: - Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.searchView(
            self,
            searchWith: searchText,
            type: [.comments, .posts, .communities, .users][indexPath.row]
        )
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FrontPageSearchView: ProgrammaticallyViewProtocol {
    func setupView() {
        self.tableView.tableHeaderView = searchHeaderLabel
        self.backgroundColor = .systemBackground
        self.alpha = appearance.alphaAtInit
    }
    
    func addSubviews() {
        self.addSubview(tableView)
    }
    
    func makeConstraints() {
        self.tableView.layoutTableHeaderView()
        self.tableView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}

private class SearchTableHeaderLabel: UIView {
    
    private lazy var searchLabel: UILabel = {
        $0.text = "front-search-search".localized
        $0.font = .boldSystemFont(ofSize: 32)
        return $0
    }(UILabel())

    init() {
        super.init(frame: .zero)
        
        self.addSubview(searchLabel)
        self.searchLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
