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
import RMModels

protocol PostScreenViewDelegate: AnyObject {
    func postView(didEmbedTappedWith url: URL)
    func postView(_ postView: PostScreenViewController.View, didWriteCommentTappedWith post: RMModels.Views.PostView)
}

extension PostScreenViewController.View {
    struct Appearance { }
}

extension PostScreenViewController {
    
    class View: UIView {
        
        struct ViewData {
            let post: RMModels.Views.PostView
            let comments: [LemmyComment]
        }
        
        weak var delegate: PostScreenViewDelegate?
                
        private let appearance = Appearance()
        
        let headerView = PostScreenHeaderView()
        var postData: RMModels.Views.PostView?
                        
        init() {
            super.init(frame: .zero)
            
            setupView()
            addSubviews()
            makeConstraints()
            
            headerView.writeNewCommentButton.addTarget(self,
                                                       action: #selector(writeCommentButtonTapped(_:)),
                                                       for: .touchUpInside)
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func bind(with viewData: RMModels.Views.PostView) {
            postData = viewData
            headerView.bind(with: viewData)
            
            if let url = viewData.post.url, let url = URL(string: url.trimmingCharacters(in: .newlines)) {
                headerView.postOutlineEmbedView.addTap {
                    self.delegate?.postView(didEmbedTappedWith: url)
                }
            }
        }
                
        func showLoadingView() {
            showActivityIndicatorView()
        }

        func hideLoadingView() {
            hideActivityIndicatorView()
        }
        
        @objc func writeCommentButtonTapped(_ sender: WriteNewCommentButton) {
            guard let post = postData else {
                return
            }
            
            delegate?.postView(self, didWriteCommentTappedWith: post)
        }
    }
}

extension PostScreenViewController.View: ProgrammaticallyViewProtocol {
    func addSubviews() {
        addSubview(headerView)
    }
    
    func makeConstraints() {
        headerView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}

class PostScreenHeaderView: UIView {
    
    // MARK: - UI Properties
    
    let postHeaderView: PostContentView = {
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return $0
    }(PostContentView())
    
    let postOutlineEmbedView: LemmyOutlinePostEmbedView = {
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return $0
    }(LemmyOutlinePostEmbedView())
    
    let writeNewCommentButton: WriteNewCommentButton = {
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return $0
    }(WriteNewCommentButton())
    
    private let mainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
    }
    
    // MARK: - Init
    
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
    
    // MARK: - Public API
    
    func bind(with postInfo: RMModels.Views.PostView) {
        postHeaderView.bind(with: postInfo, config: .fullPost)
        
        if let url = URL(string: postInfo.post.url?.trim() ?? "") {
            postOutlineEmbedView.bindData(
                .init(
                    title: postInfo.post.embedTitle,
                    description: postInfo.post.embedDescription,
                    url: url
                )
            )
        } else {
            postOutlineEmbedView.isHidden = true
        }
    }
}

// MARK: - ProgrammaticallyViewProtocol

extension PostScreenHeaderView: ProgrammaticallyViewProtocol {
    func setupView() {
        backgroundColor = UIColor.systemBackground
    }
    
    func addSubviews() {
        addSubview(mainStackView)

        mainStackView.addStackViewItems(
            .view(postHeaderView),
            .view(postOutlineEmbedView),
            .view(writeNewCommentButton)
        )
    }
    
    func makeConstraints() {
        mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - WriteNewCommentButton -

class WriteNewCommentButton: UIButton {
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        
        setTitle("Write Comment", for: .normal)
        setTitleColor(.label, for: .normal)
        setImage(Config.Image.writeComment, for: .normal)
        
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setImage(Config.Image.writeComment, for: .normal)
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: 44)
    }
}
