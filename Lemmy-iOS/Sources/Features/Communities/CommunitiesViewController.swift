//
//  CommunitiesViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/14/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CommunitiesViewController: UIViewController {

    let model = CommunitiesModel()

    private lazy var tableView = LemmyTableView(style: .plain, separator: false).then {
        $0.delegate = model
        $0.dataSource = model
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        setupView()
        addSubviews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Communities"

        model.loadCommunities()
        model.dataLoaded = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
}

extension CommunitiesViewController: ProgrammaticallyViewProtocol {
    func setupView() {
        
    }
    
    func addSubviews() {
        self.view.addSubview(tableView)
    }
    
    func makeConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
