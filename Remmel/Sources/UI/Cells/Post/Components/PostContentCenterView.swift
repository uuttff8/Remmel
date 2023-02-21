//
//  PostContentCenterView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 01.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Lightbox
import markymark
import RMModels
import RMFoundation

// MARK: - PostContentCenterView: UIView
class PostContentCenterView: UIView {
    
    // MARK: - Data
    struct ViewData {
        let imageUrl: URL?
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
    
    private let titleLabel = LMMCopyableLabel().then {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        $0.textColor = UIColor.lemmyLabel
        $0.numberOfLines = 3
    }
    
    private lazy var subtitleTextView = MarkDownTextView(
        markDownConfiguration: .attributedString,
        flavor: ContentfulFlavor(),
        styling: .init()
    ).then {
        $0.urlOpener = self
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
            titleLabel.numberOfLines = 0
            thumbailImageView.loadImage(urlString: data.imageUrl) { [self] res in
                guard case let .success(response) = res else {
                    return
                }

                setupImageViewForFullPostViewer(image: response.image, text: data.title)
            }
            
            if let subtitle = data.subtitle {
                subtitleTextView.onDidPreconfigureTextView = { tv in
                    tv.textContainer.maximumNumberOfLines = 0
                    tv.textContainer.lineBreakMode = .byTruncatingTail

                    tv.linkTextAttributes = [
                        .foregroundColor: UIColor.lemmyBlue,
                        .underlineStyle: 0,
                        .underlineColor: UIColor.clear
                    ]
                    self.setupImageTap(in: tv)
                }
                subtitleTextView.text = subtitle
            } else {
                subtitleTextView.isHidden = true
            }
            
            self.relayoutForFullPost()
        case .insideComminity, .preview:
            
            thumbailImageView.loadImage(urlString: data.imageUrl, imageSize: previewImageSize)
            
            if var subtitle = data.subtitle?.removeNewLines() {
//                subtitle = FormatterHelper.removeImageTag(fromMarkdown: subtitle)
                subtitle = ""
                #warning("FormatterHelper")
                subtitleTextView.onDidPreconfigureTextView = { tv in
                    tv.textContainer.maximumNumberOfLines = 6
                    tv.textContainer.lineBreakMode = .byTruncatingTail

                    tv.linkTextAttributes = [.foregroundColor: UIColor.lemmyLabel,
                                             .underlineStyle: 0,
                                             .underlineColor: UIColor.clear]
                    self.setupImageTap(in: tv)
                }
                
                subtitleTextView.text = subtitle
                subtitleTextView.isUserInteractionEnabled = false
            } else {
                subtitleTextView.isHidden = true
            }
        }
    }
    
    func setupImageViewForFullPostViewer(image: UIImage, text: String) {
        self.thumbailImageView.addTap {
            let image = [LightboxImage(image: image, text: text)]
            let imageController = LemmyLightboxController(images: image)
            imageController.dynamicBackground = true
            
            self.onImagePresent?(imageController)
        }
    }
    
    func relayoutForFullPost() {
        titleImageStackView.axis = .vertical
        titleImageStackView.setNeedsLayout()
        
        thumbailImageView.snp.remakeConstraints { make in
            make.height.equalTo(fullPostImageHeight)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func prepareForReuse() {
        titleLabel.text = nil
        subtitleTextView.text = nil
        thumbailImageView.image = nil
        thumbailImageView.isHidden = false
        subtitleTextView.isHidden = false
    }
    
    @objc private func handleAttachmentInTextView(_ recognizer: AttachmentTapGestureRecognizer) {
        if let image = recognizer.tappedState?.attachment.image {
            let image = [LightboxImage(image: image)]
            let imageController = LightboxController(images: image)
            imageController.dynamicBackground = true
            
            self.onImagePresent?(imageController)
        }
    }
    
    private func setupImageTap(in textView: UITextView) {
        let attachmentGesture = AttachmentTapGestureRecognizer(
            target: self, action: #selector(handleAttachmentInTextView(_:))
        )
        
        textView.addGestureRecognizer(attachmentGesture)
    }
    
    // MARK: - Overrided
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: UIView.noIntrinsicMetric)
    }
}

extension PostContentCenterView: ProgrammaticallyViewProtocol {
    func addSubviews() {
        addSubview(mainStackView)
        
        titleImageStackView.addStackViewItems(
            .view(titleLabel),
            .view(thumbailImageView)
        )
        
        mainStackView.addStackViewItems(
            .view(titleImageStackView),
            .view(subtitleTextView)
        )
    }
    
    func makeConstraints() {
        thumbailImageView.snp.makeConstraints { make in
            make.size.equalTo(previewImageSize)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension PostContentCenterView: URLOpener {
    
    func open(url: URL) {
        let link = url
        if let mention = LemmyUserMention(url: link) {
            onUserMentionTap?(mention)
            return
        }
        
        if let mention = LemmyCommunityMention(url: link) {
            onCommunityMentionTap?(mention)
            return
        }
        
        self.onLinkTap?(link)
    }
}
