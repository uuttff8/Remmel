//
//  PostScreenUI.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/26/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import SafariServices
import SnapKit

extension PostScreenViewController.View {
    struct Appearance { }
}

extension PostScreenViewController {
    
    class View: UIView {
        
        struct ViewData {
            let post: LemmyModel.PostView
            let comments: [LemmyComment]
        }
                
        let appearance = Appearance()
        
        var presentOnVc: ((UIViewController) -> Void)?
        var dismissOnVc: (() -> Void)?
        
        var headerView = PostScreenUITableCell()
                
        init() {
            super.init(frame: .zero)
            
            self.setupView()
            self.addSubviews()
            self.makeConstraints()
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func bind(with viewData: LemmyModel.PostView) {
            self.headerView.bind(with: viewData)
        }
                
        func showLoadingView() {
            self.showActivityIndicatorView()
        }

        func hideLoadingView() {
            self.hideActivityIndicatorView()
        }        
    }
}

extension PostScreenViewController.View: ProgrammaticallyViewProtocol {
    func addSubviews() {
        self.addSubview(headerView)
    }
    
    func makeConstraints() {
        self.headerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

class PostScreenUITableCell: UIView {
    
    let postHeaderView = PostContentView()
    private(set) lazy var postGreenOutlineView = LemmyGreenOutlinePostEmbed()
    
    init() {
        super.init(frame: .zero)
        
        setupView()
        addSubviews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with postInfo: LemmyModel.PostView) {
        postHeaderView.bind(with: postInfo, config: .fullPost)
        
        postGreenOutlineView.bindData(
            LemmyGreenOutlinePostEmbed.Data(
                title: postInfo.embedTitle,
                description: postInfo.embedDescription,
                url: postInfo.url
            )
        )
        
        makeConstraints()
    }
}

extension PostScreenUITableCell: ProgrammaticallyViewProtocol {
    func setupView() {
        self.backgroundColor = UIColor.systemBackground
    }
    
    func addSubviews() {
        self.addSubview(postHeaderView)
        self.addSubview(postGreenOutlineView)
    }
    
    func makeConstraints() {
        self.postHeaderView.snp.makeConstraints { (make) in
            make.top.trailing.leading.equalToSuperview()
        }
        
        if !postGreenOutlineView.isHidden {
            self.postGreenOutlineView.snp.makeConstraints { (make) in
                make.top.equalTo(postHeaderView.snp.bottom).offset(10)
                make.trailing.leading.equalToSuperview().inset(10)
                make.bottom.equalToSuperview()
            }
        } else {
            self.postHeaderView.snp.remakeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
    }
}
