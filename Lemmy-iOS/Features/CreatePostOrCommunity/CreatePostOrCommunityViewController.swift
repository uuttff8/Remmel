//
//  CreatePostOrCommunityViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CreatePostOrCommunityViewController: UIViewController {
    
    weak var coordinator: CreatePostOrCommunityCoordinator?
        
    lazy var createLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Create"
        return lbl
    }()
    
    lazy fileprivate var createPostView: ImageWithTextContainer = {
        let view = ImageWithTextContainer(text: "POST", imageString: "text.quote")
        return view
    }()
    
    lazy fileprivate var createCommunityView: ImageWithTextContainer = {
        let view = ImageWithTextContainer(text: "COMMUNITY", imageString: "doc.plaintext")
        return view
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
                
        self.view.addSubview(createLabel)
        self.view.addSubview(createPostView)
        self.view.addSubview(createCommunityView)
        
        createPostView.addTap {
            print("asdasd")
        }
        
        createCommunityView.addTap {
            print("Create community")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let viewWidth = UIScreen.main.bounds.width / 4
        
        self.createLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
        }
        
        self.createPostView.snp.makeConstraints { (make) in
            make.top.equalTo(self.createLabel.snp.bottom).offset(10)
            make.leading.equalTo(viewWidth / 2)
            make.width.equalTo(viewWidth)
        }
        
        self.createCommunityView.snp.makeConstraints { (make) in
            make.top.equalTo(self.createLabel.snp.bottom).offset(10)
            make.trailing.equalTo(-viewWidth / 2)
            make.width.equalTo(viewWidth)
        }
    }
}

private class ImageWithTextContainer: UIView {
    
    let text: String
    let imageString: String
        
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: imageString)?.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
        return iv
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = text
        return lbl
    }()
    
    init(text: String, imageString: String) {
        self.text = text
        self.imageString = imageString
        super.init(frame: .zero)
        
        self.addSubview(imageView)
        self.addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.size.equalTo(30)
            make.centerX.equalToSuperview()
        }
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.imageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
