//
//  CommentContentCenterView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 27.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import CocoaMarkdown
import Lightbox
import MarkdownUI
import SubviewAttachingTextView

private class LabeledTextViewComment: UITextView {
    override func draw(_ rect: CGRect) {
        textContainer.lineFragmentPadding = 0
        textContainerInset = .zero
    }
}

// MARK: - CommentCenterView: UIView -
class CommentCenterView: UIView {
    
    // MARK: - ViewData
    struct ViewData {
        let comment: String
        let isDeleted: Bool
    }
    
    // MARK: - Properties
    var onLinkTap: ((URL) -> Void)?
    var onUserMentionTap: ((LemmyUserMention) -> Void)?
    var onCommunityMentionTap: ((LemmyCommunityMention) -> Void)?
    var onImagePresent: ((UIViewController) -> Void)?
    
    private lazy var commentTextView = LabeledTextView().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.isScrollEnabled = false
        $0.isEditable = false
        $0.dataDetectorTypes = [.link]
        $0.delegate = self
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
    
    // MARK: - Public API
    func bind(with data: CommentCenterView.ViewData) {
        let commentText: NSAttributedString = data.isDeleted
            ? createAttributesForDeletedComment()
            : createAttributesForNormalComment(data: data)
        
        commentTextView.attributedText = commentText
        commentTextView.setNeedsLayout()
        commentTextView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lemmyBlue]
    }
    
    func prepareForReuse() {
        commentTextView.attributedText = nil
    }
        
    private func createAttributesForDeletedComment() -> NSAttributedString {
        NSAttributedString(string: "Deleted by creator", attributes: [.font: UIFont.italicSystemFont(ofSize: 16),
                                                                      .foregroundColor: UIColor.label])
    }
    
    private func createAttributesForNormalComment(data: CommentCenterView.ViewData) -> NSAttributedString {
//        let docMd = CMDocument(string: data.comment, options: .sourcepos)
//        let renderMd = CMAttributedStringRenderer(document: docMd, attributes: CMTextAttributes())
        
        let attr = NSAttributedString(document: Document(data.comment), style: .init(font: .system(size: 16)))
        
//        let attributes = NSMutableAttributedString(attributedString: renderMd.require().render())
//        attributes.addAttributes([.foregroundColor: UIColor.lemmyLabel],
//                                 range: NSRange(location: 0, length: attributes.mutableString.length))
        return attr
    }
    
    @objc private func handleAttachmentInTextView(_ recognizer: AttachmentTapGestureRecognizer) {
        if let image = recognizer.tappedState?.attachment.image {
            let image = [LightboxImage(image: image)]
            let imageController = LightboxController(images: image)
            imageController.dynamicBackground = true
            
            self.onImagePresent?(imageController)
        }
    }
}

extension CommentCenterView: ProgrammaticallyViewProtocol {
    func setupView() {
        commentTextView.backgroundColor = .clear
        
        let attachmentGesture = AttachmentTapGestureRecognizer(
            target: self, action: #selector(handleAttachmentInTextView(_:))
        )
        
        self.commentTextView.addGestureRecognizer(attachmentGesture)
    }
    
    func addSubviews() {
        self.addSubview(commentTextView)
    }
    
    func makeConstraints() {
        commentTextView.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension CommentCenterView: UITextViewDelegate {
    
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
