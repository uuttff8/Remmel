//
//  PostContentCenterView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 01.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import CocoaMarkdown
import Lightbox
import SubviewAttachingTextView
import MarkdownUI

class SimpleLabeledTextView: UITextView {
    override func draw(_ rect: CGRect) {
        textContainer.lineFragmentPadding = 0
        textContainerInset = .zero
    }
}

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
    
    private let titleLabel = LMMCopyableLabel().then {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        $0.textColor = UIColor.lemmyLabel
        $0.numberOfLines = 3
    }
    
    private lazy var subtitleTextView = LabeledTextView().then {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .lemmyLabel
        $0.isScrollEnabled = false
        $0.isSelectable = false
        $0.isEditable = false
        $0.dataDetectorTypes = [.link]
        $0.delegate = self
        $0.backgroundColor = .clear
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
            thumbailImageView.loadImage(urlString: data.imageUrl) { [self] (res) in
                guard case let .success(response) = res else { return }
                self.setupImageViewForFullPostViewer(image: response.image, text: data.title)
            }
            
            if let subtitle = data.subtitle {
                subtitleTextView.isSelectable = true
                subtitleTextView.textContainer.maximumNumberOfLines = 0

                subtitleTextView.linkTextAttributes = [.foregroundColor: UIColor.lemmyBlue,
                                                      .underlineStyle: 0,
                                                      .underlineColor: UIColor.clear]
                
                subtitleTextView.attributedText = attributtedMarkdown(subtitle)
            } else {
                subtitleTextView.isHidden = true
            }
            
            self.relayoutForFullPost()
        case .insideComminity, .preview:
            
            thumbailImageView.loadImage(urlString: data.imageUrl, imageSize: previewImageSize)
            
            if let subtitle = data.subtitle?.removeNewLines() {
                subtitleTextView.isSelectable = false
                subtitleTextView.textContainer.maximumNumberOfLines = 6
                subtitleTextView.textContainer.lineBreakMode = .byTruncatingTail
                subtitleTextView.linkTextAttributes = [.foregroundColor: UIColor.lemmyLabel,
                                                       .underlineStyle: 0,
                                                       .underlineColor: UIColor.clear]
                
                subtitleTextView.attributedText = attributtedMarkdown(subtitle)
            } else {
                subtitleTextView.isHidden = true
            }
        }
        
        self.subtitleTextView.textContainer.heightTracksTextView = true
    }
    
    func setupImageViewForFullPostViewer(image: UIImage, text: String) {
        self.thumbailImageView.addTap {
            let image = [LightboxImage(image: image, text: text)]
            let imageController = LightboxController(images: image)
            imageController.dynamicBackground = true
            
            self.onImagePresent?(imageController)
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
        subtitleTextView.text = nil
        thumbailImageView.image = nil
        thumbailImageView.isHidden = false
        subtitleTextView.isHidden = false
    }
    
    private func attributtedMarkdown(_ subtitle: String) -> NSAttributedString {
        let docMd = CMDocument(string: subtitle, options: .sourcepos)
        let renderMd = CMAttributedStringRenderer(document: docMd, attributes: CMTextAttributes())
        
        let attributes = NSMutableAttributedString(attributedString: renderMd.require().render())
        attributes.addAttributes([.foregroundColor: UIColor.lemmyLabel],
                                 range: NSRange(location: 0, length: attributes.mutableString.length))
        return attributes
    }
    
    @objc private func handleAttachmentInTextView(_ recognizer: AttachmentTapGestureRecognizer) {
        if let image = recognizer.tappedState?.attachment.image {
            let image = [LightboxImage(image: image)]
            let imageController = LightboxController(images: image)
            imageController.dynamicBackground = true
            
            self.onImagePresent?(imageController)
        }
    }
    
    // MARK: - Overrided
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: UIView.noIntrinsicMetric)
    }
}

extension PostContentCenterView: ProgrammaticallyViewProtocol {
    func setupView() {
        let attachmentGesture = AttachmentTapGestureRecognizer(
            target: self, action: #selector(handleAttachmentInTextView(_:))
        )
        
        self.subtitleTextView.addGestureRecognizer(attachmentGesture)
    }
    
    func addSubviews() {
        self.addSubview(mainStackView)
        
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
        thumbailImageView.snp.makeConstraints { (make) in
            make.size.equalTo(previewImageSize)
        }
        
        mainStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension PostContentCenterView: UITextViewDelegate {
    
    func textView(
        _ textView: UITextView,
        shouldInteractWith URL: URL,
        in characterRange: NSRange,
        interaction: UITextItemInteraction
    ) -> Bool {
        let link = URL
        if let mention = LemmyUserMention(url: link) {
            onUserMentionTap?(mention)
            return false
        }
        
        if let mention = LemmyCommunityMention(url: link) {
            onCommunityMentionTap?(mention)
            return false
        }
        
        self.onLinkTap?(link)
        return false
    }
}
