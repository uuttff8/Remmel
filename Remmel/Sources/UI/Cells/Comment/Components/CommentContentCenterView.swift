//
//  CommentContentCenterView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 27.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Lightbox
import markymark
import RMModels
import RMFoundation

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
    
    private lazy var commentTextView = MarkDownTextView(
        markDownConfiguration: .attributedString,
        flavor: ContentfulFlavor(),
        styling: .init()
    ).then {
        $0.urlOpener = self
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
        let commentText: String = data.isDeleted
            ? "*Deleted by creator*"
            : data.comment
        
        commentTextView.onDidPreconfigureTextView = { tv in
            tv.linkTextAttributes = [.foregroundColor: UIColor.lemmyBlue,
                                     .underlineStyle: 0,
                                     .underlineColor: UIColor.clear]
            
            self.setupImageTap(in: tv)
        }
        commentTextView.text = commentText
    }
    
    func prepareForReuse() {
        commentTextView.text = nil
    }
    
    private func setupImageTap(in textView: UITextView) {
        let attachmentGesture = AttachmentTapGestureRecognizer(
            target: self, action: #selector(handleAttachmentInTextView(_:))
        )
        
        textView.addGestureRecognizer(attachmentGesture)
    }
    
    @objc private func handleAttachmentInTextView(_ recognizer: AttachmentTapGestureRecognizer) {
        if let image = recognizer.tappedState?.attachment.image {
            let image = [LightboxImage(image: image)]
            let imageController = LemmyLightboxController(images: image)
            imageController.dynamicBackground = true
            
            self.onImagePresent?(imageController)
        }
    }
}

extension CommentCenterView: ProgrammaticallyViewProtocol {
    func setupView() {
        commentTextView.backgroundColor = .clear
    }
    
    func addSubviews() {
        self.addSubview(commentTextView)
    }
    
    func makeConstraints() {
        commentTextView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension CommentCenterView: URLOpener {
    
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
