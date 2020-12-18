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
    func postView(_ postView: PostScreenViewController.View, didWriteCommentTappedWith post: LemmyModel.PostView)
}

extension PostScreenViewController.View {
    struct Appearance { }
}

extension PostScreenViewController {
    
    class View: UIView {
        
        struct ViewData {
            let post: LemmyModel.PostView
            let comments: [LemmyComment]
        }
        
        weak var delegate: PostScreenViewDelegate?
                
        let appearance = Appearance()
        
        var headerView = PostScreenUITableCell()
        
        var postData: LemmyModel.PostView?
                
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
        
        func bind(with viewData: LemmyModel.PostView) {
            self.postData = viewData
            self.headerView.bind(with: viewData)
            
            if let url = viewData.url {
                headerView.postGreenOutlineView.addTap {
                    self.delegate?.postView(didEmbedTappedWith: URL(string: url)!)
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
            $0.edges.equalToSuperview()
        }
    }
}

class PostScreenUITableCell: UIView {
    
    let postHeaderView = PostContentView()
    let postGreenOutlineView = LemmyGreenOutlinePostEmbed()
    let writeNewCommentButton = WriteNewCommentButton()
    
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
        self.addSubview(writeNewCommentButton)
    }
    
    func makeConstraints() {
        self.postHeaderView.snp.makeConstraints { (make) in
            make.top.trailing.leading.equalToSuperview()
        }
        
        if !postGreenOutlineView.isHidden {
            self.postGreenOutlineView.snp.makeConstraints { (make) in
                make.top.equalTo(postHeaderView.snp.bottom).offset(10)
                make.trailing.leading.equalToSuperview().inset(10)
            }
            
            self.writeNewCommentButton.snp.makeConstraints {
                $0.top.equalTo(postGreenOutlineView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(44)
                $0.bottom.equalToSuperview()
            }
        } else {
            self.writeNewCommentButton.snp.makeConstraints {
                $0.top.equalTo(postHeaderView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(44)
                $0.bottom.equalToSuperview()
            }
        }
        
    }
}

class WriteNewCommentButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        
        setTitle("Write Comment", for: .normal)
        setImage(Config.Image.writeComment, for: .normal)
        
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setImage(Config.Image.writeComment, for: .normal)
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: 44)
    }
}
