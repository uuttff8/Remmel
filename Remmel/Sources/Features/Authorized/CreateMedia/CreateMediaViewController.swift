//
//  CreatePostOrCommunityViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

// MARK: - CreatePostOrCommunityViewController -

class CreateMediaViewController: UIViewController {

    // MARK: - Arch Properties
    
    weak var coordinator: CreateMediaCoordinator?

    // MARK: - UI Properties
    
    // animates in CreatePresentTransitionDriver, dont touch
    lazy var createView = UIView()

    private var createPostView = ImageWithTextContainer(
        text: "create-content-post".localized.uppercased(),
        image: Config.Image.textQuote
    )

    private var createCommunityView = ImageWithTextContainer(
        text: "listing-community".localized.uppercased(),
        image: Config.Image.docPlainText
    )
            
    private let buttonsStackView: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        return $0
    }(UIStackView())
    
    lazy var createLabel: UILabel = {
        $0.text = "action-create".localized
        $0.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return $0
    }(UILabel())

    // MARK: - VC Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        createView.backgroundColor = .systemBackground
        
        [createView, createLabel, buttonsStackView].forEach {
            view.addSubview($0)
        }
        
        buttonsStackView.addStackViewItems(
            .view(createPostView),
            .view(createCommunityView)
        )
        
        createPostView.addTap { [weak self] in
            self?.coordinator?.goToCreatePost()
        }
        
        createCommunityView.addTap { [weak self] in
            self?.coordinator?.goToCreateCommunity()
        }
        
        makeConstraits()
    }
    
    // MARK: - Touch Handling
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let point = touch.location(in: view)
        if !createView.frame.contains(point) {
            dismissView()
        }
    }

    // MARK: - Public API
    
    func dismissView() {
        let transition = CreateMediaTransitionDelegateImpl()
        self.transitioningDelegate = transition
        dismiss(animated: true)
    }
    
    // MARK: - Private
        
    private func makeConstraits() {
        createView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        createLabel.snp.makeConstraints {
            $0.top.equalTo(createView).inset(10)
            $0.centerX.equalToSuperview()
        }
        
        buttonsStackView.snp.makeConstraints {
            $0.top.equalTo(createLabel.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview()
        }
    }
}

// MARK: - ImageWithTextContainer -

private class ImageWithTextContainer: UIView {
    
    // MARK: - Data Properties
    
    private let text: String
    private let image: UIImage

    // MARK: - UI Properties
    
    lazy private var imageView: UIImageView = {
        $0.image = image
        return $0
    }(UIImageView())

    lazy private var titleLabel: UILabel = {
        $0.text = text
        $0.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return $0
    }(UILabel())

    // MARK: - Init
    
    init(text: String, image: UIImage) {
        self.text = text
        self.image = image
        super.init(frame: .zero)

        addSubview(imageView)
        addSubview(titleLabel)
        makeConstraits()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Constraints
    
    private func makeConstraits() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.size.equalTo(30)
            make.centerX.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.imageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
