//
//  FrontPageSearchView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 12.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol FrontPageSearchViewDelegate: AnyObject {
    func searchView(_ searchView: FrontPageSearchView, searchWith query: String, type: SearchView.TableRow)
}

extension FrontPageSearchView {
    struct Appearance {
        let fadeAnimationDuratation: TimeInterval = 0.3
        let alphaAtInit: CGFloat = 0.0
        
        let topContentInset: CGFloat = 100.0
    }
}

class FrontPageSearchView: UIView {
    weak var delegate: FrontPageSearchViewDelegate?
    
    let appearance: Appearance
    
    private var searchText: String = ""
    
    private lazy var tableView = LemmyTableView(style: .grouped, separator: true).then {
        $0.registerClass(FrontPageSearchSubjectTableCell.self)
        $0.delegate = self
        $0.dataSource = self
        $0.contentInset = .init(top: appearance.topContentInset, left: 0, bottom: 0, right: 0)
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
    func configure(with searchText: String) {
        self.searchText = searchText
        tableView.reloadData()
    }
    
    func fadeInIfNeeded() {
        guard self.alpha == 0 else { return }
        
        UIView.animate(withDuration: appearance.fadeAnimationDuratation, animations: {
            self.alpha = 1.0
        })
    }
    
    func fadeOutIfNeeded() {
        guard self.alpha == 1 else { return }
        
        UIView.animate(withDuration: appearance.fadeAnimationDuratation, animations: {
            self.alpha = 0.0
        })
    }
}

extension FrontPageSearchView: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SearchView.TableRow.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FrontPageSearchSubjectTableCell
        
        switch SearchView.TableRow.allCases[indexPath.row] {
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
        }
    }
    
    // MARK: - Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.searchView(self, searchWith: searchText, type: SearchView.TableRow.allCases[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FrontPageSearchView: ProgrammaticallyViewProtocol {
    func setupView() {
        self.backgroundColor = .systemBackground
        self.alpha = appearance.alphaAtInit
    }
    
    func addSubviews() {
        self.addSubview(tableView)
    }
    
    func makeConstraints() {
        self.tableView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
