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

protocol PostScreenViewDelegate: AnyObject {
    func postView(didEmbedTappedWith url: URL)
    func postView(_ postView: PostScreenViewController.View, didWriteCommentTappedWith post: LMModels.Views.PostView)
}

extension PostScreenViewController.View {
    struct Appearance { }
}

extension PostScreenViewController {
    
    class View: UIView {
        
        struct ViewData {
            let post: LMModels.Views.PostView
            let comments: [LemmyComment]
        }
        
        weak var delegate: PostScreenViewDelegate?
                
        let appearance = Appearance()
        
        var headerView = PostScreenHeaderView()
        
        var postData: LMModels.Views.PostView?
                
        init() {
            super.init(frame: .zero)
            
            self.setupView()
            self.addSubviews()
            self.makeConstraints()
            
            headerView.writeNewCommentButton.addTarget(self,
                                                       action: #selector(writeCommentTapped(_:)),
                                                       for: .touchUpInside)
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func bind(with viewData: LMModels.Views.PostView) {
            self.postData = viewData
            self.headerView.bind(with: viewData)
            
            if let url = viewData.post.url {
                
                headerView.postOutlineEmbedView.addAction(for: .touchUpInside) { (_) in
                    self.delegate?.postView(didEmbedTappedWith: url)
                }
                
            }
        }
                
        func showLoadingView() {
            self.showActivityIndicatorView()
        }

        func hideLoadingView() {
            self.hideActivityIndicatorView()
        }
        
        @objc func writeCommentTapped(_ sender: WriteNewCommentButton) {
            guard let post = postData else { return }
            
            self.delegate?.postView(self, didWriteCommentTappedWith: post)
        }
    }
}

extension PostScreenViewController.View: ProgrammaticallyViewProtocol {
    func addSubviews() {
        self.addSubview(headerView)
    }
    
    func makeConstraints() {
        self.headerView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}

class PostScreenHeaderView: UIView {
    
    let postHeaderView = PostContentView().then {
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    let postOutlineEmbedView = LemmyOutlinePostEmbedView().then {
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    let writeNewCommentButton = WriteNewCommentButton().then {
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private let mainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
    }
    
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
    
    func bind(with postInfo: LMModels.Views.PostView) {
        postHeaderView.bind(with: postInfo, config: .fullPost)
        
        postOutlineEmbedView.bindData(
            .init(
                title: postInfo.post.embedTitle,
                description: postInfo.post.embedDescription,
                url: postInfo.post.url
            )
        )
        
        if postInfo.post.embedTitle == nil && postInfo.post.embedDescription == nil {
            self.postOutlineEmbedView.isHidden = true
        }
    }
}

extension PostScreenHeaderView: ProgrammaticallyViewProtocol {
    func setupView() {
        self.backgroundColor = UIColor.systemBackground
    }
    
    func addSubviews() {
        self.addSubview(mainStackView)

        self.mainStackView.addStackViewItems(
            .view(postHeaderView),
            .view(postOutlineEmbedView),
            .view(writeNewCommentButton)
        )
    }
    
    func makeConstraints() {
        self.mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

class WriteNewCommentButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        
        self.setTitle("Write Comment", for: .normal)
        self.setTitleColor(.label, for: .normal)
        self.setImage(Config.Image.writeComment, for: .normal)
        
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.setImage(Config.Image.writeComment, for: .normal)
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: 44)
    }
}
