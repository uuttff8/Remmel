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
        lbl.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return lbl
    }()

    // animates in CreatePresentTransitionDriver, dont touch
    lazy var createView: UIView = UIView()

    lazy fileprivate var createPostView: ImageWithTextContainer = {
        let view = ImageWithTextContainer(text: "POST", image: Config.Image.textQuote)
        return view
    }()

    lazy fileprivate var createCommunityView: ImageWithTextContainer = {
        let view = ImageWithTextContainer(text: "COMMUNITY", image: Config.Image.docPlainText)
        return view
    }()
            
    let buttonsStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        self.createView.backgroundColor = .systemBackground

        [createView, createLabel, buttonsStackView].forEach {
            view.addSubview($0)
        }

        createPostView.addTap {
            self.coordinator?.goToCreatePost()
        }

        createCommunityView.addTap {
            self.coordinator?.goToCreateCommunity()
        }
        
        buttonsStackView.addStackViewItems(
            .view(createPostView),
            .view(createCommunityView)
        )
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.createView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        self.createLabel.snp.makeConstraints {
            $0.top.equalTo(createView).inset(10)
            $0.centerX.equalToSuperview()
        }
        
        self.buttonsStackView.snp.makeConstraints {
            $0.top.equalTo(createLabel.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview()
        }
    }

    func dismissView() {
        let transition = CreateTransitionDelegateImpl()
        self.transitioningDelegate = transition
        dismiss(animated: true)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!

        let point = touch.location(in: self.view)

        // if touch is not located in createView, then dismiss view
        if point.y <= createView.frame.origin.y {
            dismissView()
        }
    }
}

private class ImageWithTextContainer: UIView {

    let text: String
    let image: UIImage

    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = image
        return iv
    }()

    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = text
        lbl.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return lbl
    }()

    init(text: String, image: UIImage) {
        self.text = text
        self.image = image
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
