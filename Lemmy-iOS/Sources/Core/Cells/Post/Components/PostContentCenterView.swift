//
//  PostContentCenterView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 01.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import SwiftyMarkdown
import Nantes
import GSImageViewerController

// MARK: - PostContentCenterView: UIView
class PostContentCenterView: UIView {
    
    // MARK: - Data
    struct ViewData {
        let imageUrl: String?
        let title: String
        let subtitle: String?
    }
    
    // MARK: - Properties
    var onLinkTap: ((URL) -> Void)?
    var onUserMentionTap: ((LemmyUserMention) -> Void)?
    var onCommunityMentionTap: ((LemmyCommunityMention) -> Void)?
    var onImagePresent: ((UIViewController) -> Void)?
    
    private lazy var previewImageSize = CGSize(width: 110, height: 60)
    private lazy var fullPostImageHeight = UIScreen.main.bounds.height / 2.5
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        $0.textColor = UIColor.lemmyLabel
        $0.numberOfLines = 3
    }
    
    private lazy var subtitleLabel = NantesLabel().then {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.textColor = UIColor.lemmyLabel
        $0.delegate = self
    }
    
    private let thumbailImageView = UIImageView().then {
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = false
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    private let mainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
    }
    
    private let titleImageStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .top
        $0.spacing = 8
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupView()
        addSubviews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    func bind(config: PostContentType, with data: PostContentCenterView.ViewData) {
        titleLabel.text = data.title
        
        switch config {
        case .fullPost:
            subtitleLabel.numberOfLines = 0
            thumbailImageView.loadImage(urlString: data.imageUrl) { [self] (res) in
                guard case let .success(response) = res else { return }
                self.setupImageViewForFullPostViewer(image: response.image)
            }
            
            if let subtitle = data.subtitle {
                let md = SwiftyMarkdown(string: subtitle)
                md.setFontSizeForAllStyles(with: 13)
                subtitleLabel.attributedText = md.attributedString()
                
                subtitleLabel.linkAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lemmyBlue]
            }
            
            self.relayoutForFullPost()
        case .insideComminity, .preview:
            
            subtitleLabel.numberOfLines = 6
            thumbailImageView.loadImage(urlString: data.imageUrl, imageSize: previewImageSize)
            
            if let subtitle = data.subtitle?.removeNewLines() {
                let md = SwiftyMarkdown(string: subtitle)
                md.setFontSizeForAllStyles(with: 13)
                subtitleLabel.attributedText = md.attributedString()
            }
        }
        
    }
    
    func setupImageViewForFullPostViewer(image: UIImage) {
        self.thumbailImageView.addTap {
            let imageInfo   = GSImageInfo(image: image, imageMode: .aspectFit)
            let imageViewerController = GSImageViewerController(imageInfo: imageInfo)

            self.onImagePresent?(imageViewerController)
        }
    }
    
    func relayoutForFullPost() {
        self.titleImageStackView.axis = .vertical
        self.titleImageStackView.setNeedsLayout()
        
        thumbailImageView.snp.remakeConstraints { (make) in
            make.height.equalTo(fullPostImageHeight)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func prepareForReuse() {
        titleLabel.text = nil
        subtitleLabel.text = nil
        thumbailImageView.image = nil
        thumbailImageView.isHidden = false
    }
        
    // MARK: - Overrided
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: UIView.noIntrinsicMetric)
    }
}

extension PostContentCenterView: NantesLabelDelegate {
    func attributedLabel(_ label: NantesLabel, didSelectLink link: URL) {
        if let mention = LemmyUserMention(url: link) {
            onUserMentionTap?(mention)
            return
        }
        
        if let mention = LemmyCommunityMention(url: link) {
            onCommunityMentionTap?(mention)
            return
        }
        
        onLinkTap?(link)
    }
}

extension PostContentCenterView: ProgrammaticallyViewProtocol {
    func addSubviews() {
        self.addSubview(mainStackView)
        
        titleImageStackView.addStackViewItems(
            .view(titleLabel),
            .view(thumbailImageView)
        )
        
        mainStackView.addStackViewItems(
            .view(titleImageStackView),
            .view(subtitleLabel)
        )
    }
    
    func makeConstraints() {
        thumbailImageView.snp.makeConstraints { (make) in
            make.size.equalTo(previewImageSize)
        }
        
        mainStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
